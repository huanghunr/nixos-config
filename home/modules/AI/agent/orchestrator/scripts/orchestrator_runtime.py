#!/usr/bin/env python3
"""Deterministic runtime scheduler for CTF master/worker flow.

This script is designed for OpenCode-style orchestration where:
- Scrapling MCP (or any collector) writes a normalized task snapshot JSON.
- Workers solve tasks and update task metadata/evidence externally.
- This runtime script keeps queue/state deterministic in local files.
"""

from __future__ import annotations

import argparse
import json
import os
import re
import uuid
from dataclasses import dataclass
from datetime import UTC, datetime, timedelta
from pathlib import Path
from typing import Any

import yaml


KNOWN_CATEGORIES = {
    "crypto": "crypto",
    "cryptography": "crypto",
    "reverse": "reverse",
    "rev": "reverse",
    "re": "reverse",
    "pwn": "pwn",
    "web": "web",
    "forensics": "forensics",
    "forensic": "forensics",
    "misc": "misc",
    "unknown": "unknown",
}


def _utc_now() -> datetime:
    return datetime.now(UTC)


def _iso(dt: datetime) -> str:
    return dt.astimezone(UTC).replace(microsecond=0).isoformat().replace("+00:00", "Z")


def _parse_iso(ts: str | None) -> datetime | None:
    if not ts:
        return None
    text = ts.strip()
    if not text:
        return None
    if text.endswith("Z"):
        text = text[:-1] + "+00:00"
    try:
        return datetime.fromisoformat(text).astimezone(UTC)
    except ValueError:
        return None


def _slugify(value: str) -> str:
    cleaned = re.sub(r"[^a-zA-Z0-9_-]+", "-", value.strip().lower())
    cleaned = re.sub(r"-{2,}", "-", cleaned)
    return cleaned.strip("-") or "task"


def _read_yaml(path: Path) -> dict[str, Any]:
    return yaml.safe_load(path.read_text(encoding="utf-8"))


def _read_json(path: Path, default: Any) -> Any:
    if not path.exists():
        return default
    return json.loads(path.read_text(encoding="utf-8"))


def _write_json(path: Path, payload: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(
        json.dumps(payload, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
    )


def _write_yaml(path: Path, payload: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(yaml.safe_dump(payload, sort_keys=False), encoding="utf-8")


def _append_jsonl(path: Path, payload: dict[str, Any]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("a", encoding="utf-8") as f:
        f.write(json.dumps(payload, ensure_ascii=False) + "\n")


def _normalize_category(raw: str | None) -> str:
    if not raw:
        return "unknown"
    key = raw.strip().lower()
    return KNOWN_CATEGORIES.get(key, "unknown")


def _priority_score(task: dict[str, Any], cfg: dict[str, Any], now: datetime) -> float:
    p_cfg = cfg.get("prioritization", {})
    cat_weight = p_cfg.get("category_weight", {})
    category = task.get("category", "unknown")
    base = float(cat_weight.get(category, cat_weight.get("unknown", 50)))

    solved_weight = float(p_cfg.get("solved_count_weight", 0.2))
    solved_cap = int(p_cfg.get("solved_count_cap", 500))
    solved_count = int(task.get("solved_count", 0))
    base += min(solved_count, solved_cap) * solved_weight

    freshness_cfg = p_cfg.get("freshness_bonus", {})
    if freshness_cfg.get("enabled", True):
        new_window_min = int(freshness_cfg.get("new_task_window_min", 60))
        bonus = float(freshness_cfg.get("score", 20))
        seen_at = _parse_iso(task.get("meta", {}).get("first_seen_at"))
        if seen_at and now - seen_at <= timedelta(minutes=new_window_min):
            base += bonus

    change_bonus = p_cfg.get("change_bonus", {})
    recent_changes = task.get("meta", {}).get("recent_changes", [])
    for change in recent_changes:
        base += float(change_bonus.get(change, 0))

    spike_cfg = p_cfg.get("spike_boost", {})
    if spike_cfg.get("enabled", True):
        window_min = int(spike_cfg.get("window_min", 10))
        threshold = int(spike_cfg.get("threshold", 10))
        score = float(spike_cfg.get("score", 10))
        history = task.get("meta", {}).get("solved_history", [])
        if len(history) >= 2:
            latest = history[-1]
            oldest = history[0]
            latest_ts = _parse_iso(latest.get("ts"))
            oldest_ts = _parse_iso(oldest.get("ts"))
            if (
                latest_ts
                and oldest_ts
                and latest_ts - oldest_ts <= timedelta(minutes=window_min)
            ):
                delta = int(latest.get("count", 0)) - int(oldest.get("count", 0))
                if delta >= threshold:
                    base += score

    return round(base, 2)


def _event(
    event_type: str,
    task_id: str,
    reason: str = "",
    payload: dict[str, Any] | None = None,
) -> dict[str, Any]:
    return {
        "event_id": str(uuid.uuid4()),
        "event_type": event_type,
        "task_id": task_id,
        "timestamp": _iso(_utc_now()),
        "reason": reason,
        "payload": payload or {},
    }


@dataclass
class RuntimePaths:
    contest_dir: Path
    tasks_json: Path
    snapshot_json: Path
    queue_log: Path
    events_log: Path
    scoreboard: Path
    dispatch_plan: Path
    workers_json: Path


def _render_path(template: str, contest_slug: str) -> str:
    rendered = template.replace("${contest.slug}", contest_slug)
    return rendered.replace("<contest>", contest_slug)


def _resolve_base_dir(config: dict[str, Any], config_path: Path) -> Path:
    paths_cfg = config.get("paths", {})
    raw = str(paths_cfg.get("workspace_root") or "").strip()
    if not raw:
        return config_path.parent.resolve()

    expanded = Path(os.path.expanduser(raw))
    if expanded.is_absolute():
        return expanded.resolve()
    return (Path.cwd() / expanded).resolve()


def _resolve_runtime_path(base_dir: Path, path_text: str, contest_slug: str) -> Path:
    rendered = _render_path(path_text, contest_slug)
    expanded = Path(os.path.expanduser(rendered))
    if expanded.is_absolute():
        return expanded.resolve()
    return (base_dir / expanded).resolve()


def _build_paths(config: dict[str, Any], config_path: Path) -> RuntimePaths:
    contest = config.get("contest", {})
    contest_slug = _slugify(contest.get("slug", "default-contest"))
    paths_cfg = config.get("paths", {})
    base_dir = _resolve_base_dir(config, config_path)

    contest_dir_text = paths_cfg.get("contest_dir", f"./{contest_slug}")
    queue_log_text = paths_cfg.get("queue_log", f"./{contest_slug}/runtime/queue.jsonl")
    events_log_text = paths_cfg.get(
        "events_log", f"./{contest_slug}/runtime/events.jsonl"
    )
    scoreboard_text = paths_cfg.get(
        "scoreboard", f"./{contest_slug}/runtime/scoreboard.json"
    )

    contest_dir = _resolve_runtime_path(base_dir, contest_dir_text, contest_slug)
    queue_log = _resolve_runtime_path(base_dir, queue_log_text, contest_slug)
    events_log = _resolve_runtime_path(base_dir, events_log_text, contest_slug)
    scoreboard = _resolve_runtime_path(base_dir, scoreboard_text, contest_slug)

    runtime_dir = contest_dir / "runtime"
    return RuntimePaths(
        contest_dir=contest_dir,
        tasks_json=runtime_dir / "tasks.json",
        snapshot_json=runtime_dir / "latest-snapshot.json",
        queue_log=queue_log,
        events_log=events_log,
        scoreboard=scoreboard,
        dispatch_plan=runtime_dir / "dispatch-plan.json",
        workers_json=runtime_dir / "workers.json",
    )


def _write_worker_sessions(paths: RuntimePaths, tasks: list[dict[str, Any]]) -> None:
    now = _utc_now()
    existing = _read_json(paths.workers_json, default={})
    prev_by_task = existing.get("task_sessions", {})

    task_sessions: dict[str, dict[str, Any]] = {}
    active_workers: list[dict[str, Any]] = []

    for task in tasks:
        task_id = str(task.get("task_id", "")).strip()
        if not task_id:
            continue

        prev = prev_by_task.get(task_id, {})
        worker_id = task.get("worker_id") or prev.get("worker_id")
        session_id = prev.get("session_id")
        status = task.get("status", "pending")

        if not worker_id and not session_id:
            continue

        entry = {
            "task_id": task_id,
            "title": task.get("title", ""),
            "category": task.get("category", "unknown"),
            "status": status,
            "worker_id": worker_id,
            "session_id": session_id,
            "started_at": task.get("meta", {}).get("started_at"),
            "last_progress_at": task.get("last_progress_at"),
            "cooldown_until": task.get("cooldown_until"),
        }
        task_sessions[task_id] = entry

        if status == "in_progress" and worker_id:
            active_workers.append(entry)

    payload = {
        "updated_at": _iso(now),
        "active_workers": active_workers,
        "task_sessions": task_sessions,
    }
    _write_json(paths.workers_json, payload)


def _normalize_snapshot(raw_items: list[dict[str, Any]]) -> list[dict[str, Any]]:
    out = []
    for raw in raw_items:
        task_id = str(raw.get("task_id") or raw.get("id") or "").strip()
        title = str(raw.get("title") or "").strip()
        if not task_id or not title:
            continue

        out.append(
            {
                "task_id": task_id,
                "title": title,
                "category": _normalize_category(raw.get("category")),
                "points": int(raw.get("points", 0) or 0),
                "solved_count": int(raw.get("solved_count", 0) or 0),
                "url": str(raw.get("url") or ""),
                "updated_at": str(raw.get("updated_at") or _iso(_utc_now())),
                "attachments_hash": str(raw.get("attachments_hash") or ""),
                "hints_hash": str(raw.get("hints_hash") or ""),
            }
        )
    return out


def _ensure_task_workspace(contest_dir: Path, task: dict[str, Any]) -> None:
    category = task.get("category", "unknown")
    task_slug = task.get("meta", {}).get("task_slug") or _slugify(
        task.get("title", "task")
    )
    task_dir = contest_dir / "tasks" / category / task_slug
    (task_dir / "attachments").mkdir(parents=True, exist_ok=True)
    (task_dir / "hints").mkdir(parents=True, exist_ok=True)
    (task_dir / "working").mkdir(parents=True, exist_ok=True)
    (task_dir / "result").mkdir(parents=True, exist_ok=True)

    snapshot = {
        "task_id": task.get("task_id"),
        "title": task.get("title"),
        "category": category,
        "points": int(task.get("points", 0)),
        "solved_count": int(task.get("solved_count", 0)),
        "url": task.get("url", ""),
        "updated_at": task.get("updated_at"),
        "attachments_hash": task.get("attachments_hash", ""),
        "hints_hash": task.get("hints_hash", ""),
        "priority_score": float(task.get("priority_score", 0)),
        "status": task.get("status", "pending"),
    }
    _write_yaml(task_dir / "task.yaml", snapshot)


def _sync_tasks(
    config: dict[str, Any],
    paths: RuntimePaths,
    snapshot_path: Path,
) -> tuple[list[dict[str, Any]], list[dict[str, Any]]]:
    now = _utc_now()
    existing = _read_json(paths.tasks_json, default=[])
    by_id = {x["task_id"]: x for x in existing}

    snapshot_data = _read_json(snapshot_path, default=[])
    incoming = _normalize_snapshot(snapshot_data)
    events: list[dict[str, Any]] = []

    for item in incoming:
        task_id = item["task_id"]
        previous = by_id.get(task_id)
        if previous is None:
            task = {
                **item,
                "status": "pending",
                "attempts": 0,
                "last_progress_at": _iso(now),
                "priority_score": 0,
                "meta": {
                    "first_seen_at": _iso(now),
                    "recent_changes": ["new_task"],
                    "solved_history": [
                        {"ts": _iso(now), "count": item["solved_count"]}
                    ],
                    "task_slug": _slugify(item["title"]),
                },
            }
            by_id[task_id] = task
            events.append(
                _event("new_task", task_id, "Task discovered", {"title": item["title"]})
            )
            continue

        previous_changes: list[str] = []
        if previous.get("hints_hash", "") != item["hints_hash"]:
            previous_changes.append("hint_updated")
            events.append(_event("hint_updated", task_id, "Hints changed"))

        if previous.get("attachments_hash", "") != item["attachments_hash"]:
            previous_changes.append("attachment_updated")
            events.append(_event("attachment_updated", task_id, "Attachments changed"))

        if int(previous.get("solved_count", 0)) != item["solved_count"]:
            previous_changes.append("solve_count_changed")
            events.append(
                _event(
                    "solve_count_changed",
                    task_id,
                    "Solved count changed",
                    {
                        "old": int(previous.get("solved_count", 0)),
                        "new": item["solved_count"],
                    },
                )
            )

        solved_history = previous.get("meta", {}).get("solved_history", [])
        solved_history.append({"ts": _iso(now), "count": item["solved_count"]})
        solved_history = solved_history[-12:]

        previous_meta = previous.get("meta", {})
        previous_meta["recent_changes"] = previous_changes
        previous_meta["solved_history"] = solved_history

        previous.update(item)
        previous["meta"] = previous_meta

    tasks = list(by_id.values())
    for task in tasks:
        task["priority_score"] = _priority_score(task, config, now)
        if "recent_changes" not in task.get("meta", {}):
            task.setdefault("meta", {})["recent_changes"] = []

    tasks.sort(key=lambda x: x["priority_score"], reverse=True)

    for task in tasks:
        _ensure_task_workspace(paths.contest_dir, task)

    _write_json(paths.tasks_json, tasks)
    _write_worker_sessions(paths, tasks)

    for ev in events:
        _append_jsonl(paths.events_log, ev)

    queue_entry = {
        "ts": _iso(now),
        "kind": "sync",
        "task_count": len(tasks),
        "top_tasks": [x["task_id"] for x in tasks[:5]],
    }
    _append_jsonl(paths.queue_log, queue_entry)
    return tasks, events


def _apply_stop_rules(
    config: dict[str, Any], task: dict[str, Any], now: datetime
) -> str | None:
    stop_cfg = config.get("stop_rules", {})
    hard_timeout_min = int(stop_cfg.get("hard_timeout_min", 45))
    no_progress_min = int(stop_cfg.get("no_progress_min", 15))
    max_failed_attempts = int(stop_cfg.get("max_failed_attempts", 5))

    started_at = _parse_iso(task.get("meta", {}).get("started_at"))
    last_progress = _parse_iso(task.get("last_progress_at"))
    attempts = int(task.get("attempts", 0))

    if started_at and now - started_at >= timedelta(minutes=hard_timeout_min):
        return "hard_timeout"
    if last_progress and now - last_progress >= timedelta(minutes=no_progress_min):
        return "no_progress"
    if attempts >= max_failed_attempts:
        return "max_failed_attempts"
    return None


def _recommended_poll_seconds(config: dict[str, Any], now: datetime) -> int:
    polling = config.get("collection", {}).get("polling", {})
    normal = int(polling.get("normal_interval_sec", 300))
    high_freq = int(polling.get("high_freq_interval_sec", 60))
    before_min = int(polling.get("high_freq_before_release_min", 3))
    after_min = int(polling.get("high_freq_after_release_min", 5))

    release_windows = config.get("contest", {}).get("release_windows", [])
    for release_ts in release_windows:
        release_dt = _parse_iso(str(release_ts))
        if not release_dt:
            continue
        if (
            release_dt - timedelta(minutes=before_min)
            <= now
            <= release_dt + timedelta(minutes=after_min)
        ):
            return high_freq
    return normal


def _schedule(config: dict[str, Any], paths: RuntimePaths) -> dict[str, Any]:
    now = _utc_now()
    tasks = _read_json(paths.tasks_json, default=[])

    scheduler = config.get("scheduler", {})
    max_concurrency = int(scheduler.get("max_concurrency", 3))
    cooldown_min = int(scheduler.get("cooldown_min", 20))

    dispatched: list[dict[str, Any]] = []
    events: list[dict[str, Any]] = []

    for task in tasks:
        status = task.get("status")
        if status == "cooldown":
            cooldown_until = _parse_iso(task.get("cooldown_until"))
            if cooldown_until and now >= cooldown_until:
                task["status"] = "pending"
                task.pop("cooldown_until", None)
                events.append(
                    _event("task_resumed", task["task_id"], "Cooldown expired")
                )

    for task in tasks:
        if task.get("status") != "in_progress":
            continue
        reason = _apply_stop_rules(config, task, now)
        if reason:
            task["status"] = "cooldown"
            task["cooldown_until"] = _iso(now + timedelta(minutes=cooldown_min))
            task.pop("worker_id", None)
            events.append(
                _event(
                    "task_cooldown", task["task_id"], f"Stop rule triggered: {reason}"
                )
            )

    in_progress = [x for x in tasks if x.get("status") == "in_progress"]
    slots = max(0, min(max_concurrency, 3) - len(in_progress))

    pending = [x for x in tasks if x.get("status") == "pending"]
    pending.sort(key=lambda x: x.get("priority_score", 0), reverse=True)

    for idx, task in enumerate(pending[:slots], start=1):
        task["status"] = "in_progress"
        task["worker_id"] = f"worker-{idx}"
        task.setdefault("meta", {})["started_at"] = _iso(now)
        dispatched.append(
            {
                "task_id": task["task_id"],
                "title": task.get("title", ""),
                "category": task.get("category", "unknown"),
                "priority_score": task.get("priority_score", 0),
                "worker_id": task["worker_id"],
            }
        )
        events.append(
            _event(
                "worker_started",
                task["task_id"],
                "Scheduled for solving",
                {"worker_id": task["worker_id"]},
            )
        )

    _write_json(paths.tasks_json, tasks)
    _write_worker_sessions(paths, tasks)
    for task in tasks:
        _ensure_task_workspace(paths.contest_dir, task)

    for ev in events:
        _append_jsonl(paths.events_log, ev)

    queue_entry = {
        "ts": _iso(now),
        "kind": "dispatch",
        "in_progress": len([x for x in tasks if x.get("status") == "in_progress"]),
        "dispatched": [x["task_id"] for x in dispatched],
    }
    _append_jsonl(paths.queue_log, queue_entry)

    solved = len([x for x in tasks if x.get("status") == "solved"])
    pending_count = len([x for x in tasks if x.get("status") == "pending"])
    _write_json(
        paths.scoreboard,
        {
            "updated_at": _iso(now),
            "total": len(tasks),
            "solved": solved,
            "in_progress": len([x for x in tasks if x.get("status") == "in_progress"]),
            "pending": pending_count,
            "cooldown": len([x for x in tasks if x.get("status") == "cooldown"]),
            "failed": len([x for x in tasks if x.get("status") == "failed"]),
        },
    )

    plan = {
        "generated_at": _iso(now),
        "max_concurrency": min(max_concurrency, 3),
        "recommended_poll_interval_sec": _recommended_poll_seconds(config, now),
        "dispatch": dispatched,
    }
    _write_json(paths.dispatch_plan, plan)
    return plan


def _init_layout(paths: RuntimePaths, config: dict[str, Any]) -> None:
    (paths.contest_dir / "tasks").mkdir(parents=True, exist_ok=True)
    (paths.contest_dir / "runtime").mkdir(parents=True, exist_ok=True)
    contest = config.get("contest", {})
    contest_yaml = {
        "slug": contest.get("slug", "unknown-contest"),
        "platform": contest.get("platform", "unknown"),
        "base_url": contest.get("base_url", ""),
        "start_time": contest.get("start_time", ""),
        "end_time": contest.get("end_time", ""),
        "release_windows": contest.get("release_windows", []),
    }
    _write_yaml(paths.contest_dir / "contest.yaml", contest_yaml)
    if not paths.tasks_json.exists():
        _write_json(paths.tasks_json, [])
    if not paths.scoreboard.exists():
        _write_json(
            paths.scoreboard,
            {
                "updated_at": _iso(_utc_now()),
                "total": 0,
                "solved": 0,
                "in_progress": 0,
                "pending": 0,
                "cooldown": 0,
                "failed": 0,
            },
        )
    if not paths.workers_json.exists():
        _write_json(
            paths.workers_json,
            {
                "updated_at": _iso(_utc_now()),
                "active_workers": [],
                "task_sessions": {},
            },
        )


def parse_args() -> argparse.Namespace:
    p = argparse.ArgumentParser(description="CTF runtime orchestrator helper")
    p.add_argument("--config", required=True, help="Path to orchestrator yaml config")
    p.add_argument(
        "--snapshot",
        default="",
        help="Normalized collector JSON path (list of tasks). Default: <contest>/runtime/latest-snapshot.json",
    )
    p.add_argument(
        "--mode",
        choices=["init", "sync", "schedule", "full"],
        default="full",
        help="init=create dirs, sync=ingest snapshot, schedule=dispatch only, full=sync+schedule",
    )
    return p.parse_args()


def main() -> None:
    args = parse_args()
    config_path = Path(os.path.expanduser(args.config)).resolve()
    config = _read_yaml(config_path)
    paths = _build_paths(config, config_path)
    _init_layout(paths, config)

    if args.mode == "init":
        print(
            json.dumps(
                {
                    "status": "ok",
                    "mode": "init",
                    "contest_dir": str(paths.contest_dir),
                    "snapshot": str(paths.snapshot_json),
                    "workers": str(paths.workers_json),
                }
            )
        )
        return

    if args.mode in {"sync", "full"}:
        if args.snapshot:
            snapshot_path = Path(os.path.expanduser(args.snapshot)).resolve()
        else:
            snapshot_path = paths.snapshot_json
        if not snapshot_path.exists():
            raise SystemExit(f"snapshot not found: {snapshot_path}")
        tasks, events = _sync_tasks(config, paths, snapshot_path)
        print(
            json.dumps(
                {
                    "status": "ok",
                    "mode": "sync",
                    "tasks": len(tasks),
                    "events": len(events),
                }
            )
        )

    if args.mode in {"schedule", "full"}:
        plan = _schedule(config, paths)
        print(
            json.dumps(
                {"status": "ok", "mode": "schedule", "dispatch": plan["dispatch"]}
            )
        )


if __name__ == "__main__":
    main()
