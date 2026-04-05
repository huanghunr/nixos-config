# Collector Snapshot Format

`orchestrator_runtime.py` expects a normalized JSON array as input (`--snapshot`).

## Minimal Example

```json
[
  {
    "task_id": "42",
    "title": "easy-rev",
    "category": "reverse",
    "points": 100,
    "solved_count": 120,
    "url": "https://ctf.example.com/challenges#42",
    "updated_at": "2026-04-01T12:00:00Z",
    "attachments_hash": "sha256:...",
    "hints_hash": "sha256:..."
  }
]
```

## Required Fields

- `task_id` (string)
- `title` (string)

## Optional Fields

- `category` (`crypto`, `reverse`, `pwn`, `web`, `forensics`, `misc`, `unknown`)
- `points` (integer)
- `solved_count` (integer)
- `url` (string)
- `updated_at` (ISO8601 UTC)
- `attachments_hash` (string)
- `hints_hash` (string)

## Notes

- `id` is accepted as fallback for `task_id`.
- Category aliases (`rev`, `re`, `cryptography`, `forensic`) are normalized automatically.
- Recommended snapshot path per contest:
  - `./<contest>/runtime/latest-snapshot.json`
- The runtime script creates or updates:
  - `<contest>/contest.yaml`
  - `<contest>/tasks/<category>/<task>/task.yaml`
  - `<contest>/runtime/tasks.json`
  - `<contest>/runtime/events.jsonl`
  - `<contest>/runtime/dispatch-plan.json`
  - `<contest>/runtime/workers.json`
