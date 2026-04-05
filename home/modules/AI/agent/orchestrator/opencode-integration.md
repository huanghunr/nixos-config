# OpenCode Integration Guide for CTF Master/Worker Orchestrator

This guide explains how to run the architecture in OpenCode.

## 1) Is this architecture usable in OpenCode?

Yes. The architecture is tool-agnostic and maps well to OpenCode:

- **Master agent session** in OpenCode = scheduler/collector coordinator.
- **Worker agent sessions** in OpenCode = one session per challenge task.
- **MCP servers** in OpenCode = data and browser automation layer (Scrapling MCP, optional others).
- **Local files** in workspace = persistent runtime state (`queue`, `events`, `task snapshots`, `artifacts`).

## 2) Minimal OpenCode Mapping

- Runtime command entrypoints (always available after Home Manager switch):
  - `ctf-orch-bootstrap`
  - `ctf-orch-run`
- Runtime config location:
  - `./.agentsec/orchestrator/<contest>.yaml`
- Master prompt source:
  - `home/modules/agent/ctf-master-agent.md`
  - `home/modules/agent/ctf-orchestrator-design.md`
- Runtime contract files:
  - `home/modules/agent/orchestrator/schemas/task.schema.json`
  - `home/modules/agent/orchestrator/schemas/event.schema.json`
  - `home/modules/agent/orchestrator/state-machine.md`
- Runtime config template:
  - `home/modules/agent/orchestrator/orchestrator-config.example.yaml`
- Runtime scheduler script:
  - `home/modules/agent/orchestrator/scripts/orchestrator_runtime.py`
- Snapshot contract:
  - `home/modules/agent/orchestrator/snapshot-format.md`

## 3) Recommended Execution Flow in OpenCode

1. Start one **master session**.
2. Master uses Scrapling MCP to fetch challenge metadata and writes task snapshots.
3. Master runs runtime scheduler script to compute priority score and dispatch up to 3 tasks.
4. For each task, start/continue a **worker session** bound to that task directory.
5. Worker reports structured result (`solved`, `blocked`, `failed`, progress evidence).
6. Master updates task state and logs one event record per transition.
7. On solved task, master either auto-submits or prints candidate flag, then writes `wp` and `enhance` artifacts.

## 4) Concurrency in OpenCode

OpenCode does not require special architecture support for this pattern:

- Keep a deterministic queue file and scheduler loop.
- Treat each worker as an independent unit with strict state transitions.
- Enforce max concurrency at scheduler layer (`max_concurrency: 3`).

## 5) Scrapling MCP Notes

To work in OpenCode, Scrapling MCP only needs to be configured as an MCP server entry usable by the master session.

Master-side responsibilities:
- login/session bootstrap
- challenge list polling
- challenge detail extraction
- attachment/hint change detection

Worker sessions should preferably use short-lived tokens or scoped credentials instead of master account secrets.

## 6) Operational Safety

- Keep credentials in environment variables or secret manager.
- Redact sensitive values from logs.
- Keep `events.jsonl` append-only for auditability.
- Use explicit stop rules for hard tasks (timeout/no progress/max attempts).

## 7) Practical Next Step

If you want full automation in OpenCode, implement one executable scheduler script that:

- reads config
- validates task/event payloads against schema
- enforces state machine
- calls MCP collection APIs
- dispatches/resumes worker sessions

With that script, OpenCode becomes the control plane UI, while orchestration logic remains deterministic in files.

This repository already includes that script:

```bash
ctf-orch-run \
  --config ./.agentsec/orchestrator/<contest>.yaml \
  --snapshot ./<contest>/runtime/latest-snapshot.json \
  --mode full
```

## 8) Production Config

Use the ready-to-run config and guide in this repo:

- `home/modules/agent/orchestrator/orchestrator-config.opencode.yaml`
- `home/modules/agent/orchestrator/orchestrator-config-guide.md`
