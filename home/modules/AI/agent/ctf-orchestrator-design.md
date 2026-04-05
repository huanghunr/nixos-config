# CTF Master/Worker Orchestrator Design (Scrapling MCP)

> Goal: build a sustainable CTF automation system where a master agent handles collection/scheduling and worker agents handle solving/output (`flag`, `wp`, `enhance`).

## 1) Scope and Responsibilities

- **Master agent**
  - Reads platform credentials (prefer environment variables or secret manager; never hardcode).
  - Uses Scrapling MCP to log in and fetch challenge list/details/attachments/hints/solve counts/update timestamps.
  - Creates contest/challenge folders automatically.
  - Maintains queue state and enforces **max 3 concurrent workers**.
  - Priority policy: `crypto`, `reverse` first; then other categories; within same priority tier, prefer higher solve count.
  - Tracks challenge state changes (new challenge, attachment updates, hint updates, solve-count changes).
- **Worker agent**
  - Claims one challenge task and runs solve workflow.
  - Stops and returns control to scheduler when timeout/hard-task threshold is hit.
  - On success, outputs flag (auto-submit or print-only by config) and produces `wp` + `enhance` artifacts.

## 2) Suggested Directory Layout

```text
<ctf-root>/
  <contest-slug>/
    contest.yaml                   # contest metadata
    tasks/
      <category>/<task-slug>/
        task.yaml                  # challenge snapshot (title, points, solve count, updated_at, URL)
        attachments/               # downloaded files
        hints/                     # hint history (timestamped)
        working/                   # worker scratch space (scripts/notes)
        result/
          flag.txt                 # success output (can be redacted)
          wp.md                    # writeup
          enhance.md               # environment improvement note
    runtime/
      latest-snapshot.json         # collector snapshot input
      queue.jsonl                  # scheduling log
      events.jsonl                 # collection/change events
      scoreboard.json              # solve progress
      workers.json                 # worker session mapping for restart
```

## 3) Component Model

1. **Collector**
   - Uses Scrapling MCP for login/list/detail/download.
   - Emits normalized events: `new_task`, `hint_updated`, `attachment_updated`, `solve_count_changed`.

2. **Normalizer**
   - Maps platform-specific fields into unified schema:
     - `task_id`, `title`, `category`, `points`, `solved_count`, `updated_at`, `attachments_hash`, `hints_hash`.

3. **Prioritizer**
   - Produces sortable `priority_score`.
   - Recommended weights:
     - `category_weight`: crypto/reverse = 100, others = 50
     - `solved_weight`: `min(solved_count, 500) * 0.2`
     - `freshness_weight`: +20 for newly released tasks in last hour
     - `changed_weight`: +15 for hint/attachment updates
   - Example:
     - `priority_score = category_weight + solved_weight + freshness_weight + changed_weight`

4. **Scheduler**
   - Enforces `max_concurrency = 3`.
   - Dispatches highest-priority queued tasks.
   - If a task is marked hard/timeout, demote to cooldown and switch to next task.

5. **Worker Runner**
   - Binds each worker to one challenge workspace.
   - Tracks lifecycle: `started -> probing -> solving -> blocked/solved`.
   - Returns structured outcome: `status`, `flag`, `evidence`, `reason`.

6. **Submitter (optional)**
   - Modes:
     - `auto_submit=true`: submit automatically and record response
     - `auto_submit=false`: print candidate flag only

7. **Reporter**
   - Generates `wp.md` and `enhance.md` for solved challenges.
   - `enhance` focuses on missing tooling, reusable scripts, and workflow improvements.

## 4) Scheduling and Cut-Loss Strategy

### 4.1 Concurrency Rule

- Global cap: `max_concurrency = 3`.
- Each scheduling cycle:
  1. reclaim slots from finished/failed tasks
  2. dispatch highest-priority pending tasks

### 4.2 Hard-Task Auto Stop

Move task to cooldown when **any** threshold is met:

- Runtime exceeds `T_hard` (e.g., 45 min) with no meaningful progress.
- Consecutive strategy failures exceed `N` (e.g., 5).
- No new evidence for `M` minutes (no new scripts/intermediate artifacts).

Cooldown task can be resumed on signals:
- new hint
- updated attachment
- significant solve-count increase

### 4.3 Prefer High-Solve Tasks

- Within same category tier, sort by `solved_count` descending.
- If solve count spikes in short window, boost priority immediately.

## 5) Polling and Time-Based Triggers

Support both periodic polling and explicit release-time wake-up:

1. **Periodic polling**
   - normal: every 5 minutes
   - critical contest window: every 1 minute

2. **Scheduled wake-up**
   - user provides organizer-announced release time
   - force refresh around the event window (e.g., -2 min and +1 min)

3. **Change detection**
   - hash attachments; hash change => `attachment_updated`
   - hash hints text; hash change => `hint_updated`

## 6) Credentials and Security

- Do not place account/password in prompt text or repository files.
- Recommended:
  - `.env` + local secret manager (1Password CLI / pass / sops)
  - pass short-lived session token to workers instead of master credentials
  - redact sensitive data in logs (`flag`, `cookie`, `token`)

## 7) MVP Rollout Plan

1. **Phase 1 (bootstrap)**
   - implement collection + normalization + directory creation + queue
   - start with single worker

2. **Phase 2 (scheduler)**
   - add prioritization + max-3 concurrency
   - add hard-stop + cooldown

3. **Phase 3 (closed loop)**
   - add configurable auto-submit
   - add writeup/enhance generation templates
   - add release-time trigger + hint/attachment change trigger

## 8) Example Config

```yaml
orchestrator:
  max_concurrency: 3
  auto_submit: false
  poll_interval_sec: 300
  high_freq_poll_interval_sec: 60
  hard_timeout_min: 45
  no_progress_min: 15
  max_failed_attempts: 5
  category_priority:
    crypto: 100
    reverse: 100
    pwn: 70
    web: 70
    forensics: 65
    misc: 60
  solved_count_weight: 0.2
  changed_bonus:
    hint_updated: 15
    attachment_updated: 15
```

## 9) Agent Isolation Policy

- `ctf-master-agent` owns scheduler directives and worker dispatch:
  - max 3 concurrent workers
  - hard-stop + cooldown
  - explicit priority scoring
  - configurable submit mode
- `security-agent` remains single-task/manual analysis and does not run multi-agent orchestration.

## 10) Implementation Artifacts in This Repository

- Task schema: `home/modules/agent/orchestrator/schemas/task.schema.json`
- Event schema: `home/modules/agent/orchestrator/schemas/event.schema.json`
- Config template: `home/modules/agent/orchestrator/orchestrator-config.example.yaml`
- State machine: `home/modules/agent/orchestrator/state-machine.md`
- Runtime scheduler: `home/modules/agent/orchestrator/scripts/orchestrator_runtime.py`
- Master prompt: `home/modules/agent/ctf-master-agent.md`
- Worker prompt: `home/modules/agent/ctf-worker-agent.md`

Use these as the contract boundary between collector/scheduler/workers.

## 11) OpenCode Compatibility

This architecture can run in OpenCode. See:

- `home/modules/agent/orchestrator/opencode-integration.md`

The key idea is: keep orchestration logic deterministic in workspace files (queue/events/state), and use OpenCode sessions + MCP as execution/control surfaces.
