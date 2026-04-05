#!/usr/bin/env python3
"""Generate runtime orchestrator config outside the Nix-managed repo.

Use this script when contest metadata changes frequently and you do not want
to edit tracked files (which may trigger rebuild workflows).
"""

from __future__ import annotations

import argparse
import os
from pathlib import Path
from textwrap import dedent


def _sanitize_slug(raw: str) -> str:
    return "".join(c if c.isalnum() or c in "-_" else "-" for c in raw.strip()).strip(
        "-"
    )


def _yaml_list(items: list[str], indent: int = 2) -> str:
    space = " " * indent
    if not items:
        return f"{space}[]"
    return "\n".join(f'{space}- "{x}"' for x in items)


def build_config(
    contest_slug: str,
    platform: str,
    base_url: str,
    start_time: str,
    end_time: str,
    release_windows: list[str],
    submission_mode: str,
    max_concurrency: int,
    workspace_root: str,
) -> str:
    return dedent(
        f'''\
        version: 1
        profile: "balanced"

        contest:
          slug: "{contest_slug}"
          platform: "{platform}"
          base_url: "{base_url}"
          timezone: "UTC"
          start_time: "{start_time}"
          end_time: "{end_time}"
          release_windows:
        {_yaml_list(release_windows, indent=4)}

        credentials:
          username_env: "CTF_USERNAME"
          password_env: "CTF_PASSWORD"
          session_token_env: "CTF_SESSION_TOKEN"

        mcp:
          scrapling:
            enabled: true
            server_name: "scrapling-mcp"
            timeout_sec: 30
            retry:
              attempts: 3
              backoff_sec: 2

        collection:
          polling:
            normal_interval_sec: 300
            high_freq_interval_sec: 60
            high_freq_before_release_min: 3
            high_freq_after_release_min: 5
          change_detection:
            check_hints: true
            check_attachments: true
            attachment_hash_algo: "sha256"
            hint_hash_algo: "sha256"

        scheduler:
          enabled: true
          max_concurrency: {max_concurrency}
          queue_strategy: "priority_desc"
          dispatch_tick_sec: 15
          cooldown_min: 20
          retry_blocked_after_min: 10

        prioritization:
          category_weight:
            crypto: 100
            reverse: 100
            pwn: 70
            web: 70
            forensics: 65
            misc: 60
            unknown: 50
          solved_count_weight: 0.2
          solved_count_cap: 500
          freshness_bonus:
            enabled: true
            new_task_window_min: 60
            score: 20
          change_bonus:
            hint_updated: 15
            attachment_updated: 15
          spike_boost:
            enabled: true
            window_min: 10
            threshold: 10
            score: 10

        stop_rules:
          hard_timeout_min: 45
          no_progress_min: 15
          max_failed_attempts: 5
          on_trigger: "move_to_cooldown"

        workers:
          solver_mode: "subagent"
          pass_credentials: "token_only"
          heartbeat_sec: 30
          result_contract: "event.schema.v1"

        submission:
          mode: "{submission_mode}"
          auto_submit_requires_confidence: 0.9
          accepted_status_text:
            - "Correct"
            - "Accepted"

        artifacts:
          generate_writeup: true
          generate_enhance: true
          writeup_language: "zh-CN"
          enhance_language: "zh-CN"

        paths:
          workspace_root: "{workspace_root}"
          contests_root: "./"
          contest_dir: "./${{contest.slug}}"
          queue_log: "./${{contest.slug}}/runtime/queue.jsonl"
          events_log: "./${{contest.slug}}/runtime/events.jsonl"
          scoreboard: "./${{contest.slug}}/runtime/scoreboard.json"

        observability:
          log_level: "info"
          redact:
            - "flag"
            - "cookie"
            - "token"
          metrics:
            enabled: true
            flush_interval_sec: 60
        '''
    )


def parse_args() -> argparse.Namespace:
    p = argparse.ArgumentParser(
        description="Create runtime orchestrator config outside repo"
    )
    p.add_argument(
        "--contest-slug", required=True, help="Contest identifier, e.g. tsgctf-2026"
    )
    p.add_argument(
        "--platform", default="ctfd", help="Platform type, e.g. ctfd/rctf/custom"
    )
    p.add_argument("--base-url", required=True, help="Contest base URL")
    p.add_argument(
        "--start-time", required=True, help="ISO8601 UTC, e.g. 2026-04-01T00:00:00Z"
    )
    p.add_argument(
        "--end-time", required=True, help="ISO8601 UTC, e.g. 2026-04-03T00:00:00Z"
    )
    p.add_argument(
        "--release-window", action="append", default=[], help="ISO8601 UTC, can repeat"
    )
    p.add_argument(
        "--submission-mode",
        choices=["print_only", "auto_submit"],
        default="print_only",
    )
    p.add_argument("--max-concurrency", type=int, default=3)
    p.add_argument(
        "--output",
        default="",
        help="Output path. Default: ./.agentsec/orchestrator/<contest_slug>.yaml",
    )
    p.add_argument(
        "--workspace-root",
        default="",
        help="Workspace root for runtime files. Default: current working directory.",
    )
    return p.parse_args()


def main() -> None:
    args = parse_args()
    slug = _sanitize_slug(args.contest_slug)
    output = args.output.strip()
    workspace_root = args.workspace_root.strip()
    if not workspace_root:
        workspace_root = os.getcwd()
    workspace_root = str(Path(os.path.expanduser(workspace_root)).resolve())

    if not output:
        output = str(
            (Path.cwd() / ".agentsec" / "orchestrator" / f"{slug}.yaml").resolve()
        )

    out_path = Path(output)
    out_path.parent.mkdir(parents=True, exist_ok=True)

    yaml_text = build_config(
        contest_slug=slug,
        platform=args.platform,
        base_url=args.base_url,
        start_time=args.start_time,
        end_time=args.end_time,
        release_windows=args.release_window,
        submission_mode=args.submission_mode,
        max_concurrency=max(1, min(args.max_concurrency, 3)),
        workspace_root=workspace_root,
    )
    out_path.write_text(yaml_text, encoding="utf-8")
    print(str(out_path))


if __name__ == "__main__":
    main()
