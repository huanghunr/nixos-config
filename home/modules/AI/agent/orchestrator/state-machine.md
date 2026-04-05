# CTF Task State Machine

## States

- `pending`: task discovered and waiting for scheduling.
- `in_progress`: currently assigned to a worker.
- `blocked`: worker stopped due to temporary blocker.
- `cooldown`: task paused by scheduler due to hard-task policy.
- `solved`: flag accepted (or verified in print-only mode).
- `failed`: unrecoverable failure.

## Transitions

1. `pending -> in_progress`
   - condition: available worker slot and highest priority.

2. `in_progress -> solved`
   - condition: worker returns valid flag; submit success (or print-only verification).

3. `in_progress -> blocked`
   - condition: worker reports environment/tool/platform blocker.

4. `in_progress -> cooldown`
   - condition: hard timeout OR no-progress timeout OR max strategy failures reached.

5. `blocked -> pending`
   - condition: blocker resolved and task should be retried.

6. `cooldown -> pending`
   - condition: cooldown period expired OR external signal received (new hint/attachment update/solve-count spike).

7. `in_progress -> failed`
   - condition: explicit fatal error (invalid task data, corrupted files, unrecoverable runtime fault).

## Scheduler Invariants

- At most `max_concurrency` tasks can be `in_progress` at the same time.
- A solved task cannot transition to any other state.
- A failed task cannot transition unless manually reset.
- Every state transition must emit one runtime event into `events.jsonl`.

## Worker Contract

Worker output should include:

```json
{
  "task_id": "...",
  "status": "solved | blocked | failed | in_progress",
  "flag": "optional",
  "reason": "human-readable summary",
  "evidence": ["paths or notes"],
  "attempts_increment": 1,
  "progress": true
}
```

Scheduler uses this output to decide transition and queue ordering.
