# Runtime Config Workflow (No Nix Rebuild Required)

If you do not want to edit repository files for each contest, use runtime config generation.

## Why this works

- Nix-managed files in the repo remain unchanged.
- Contest-specific config is generated under current workspace:
  - `./.agentsec/orchestrator/<contest>.yaml`
- You can give contest info directly to AI, and AI runs one command to generate config.

## Command

```bash
ctf-orch-bootstrap \
  --contest-slug "tsgctf-2026" \
  --platform "ctfd" \
  --base-url "https://ctf.example.com" \
  --start-time "2026-04-01T00:00:00Z" \
  --end-time "2026-04-03T00:00:00Z" \
  --release-window "2026-04-01T12:00:00Z" \
  --submission-mode "print_only"
```

The script prints the generated config path.

You can also use the Home Manager wrapper command (after `home-manager switch`):

```bash
ctf-orch-bootstrap \
  --contest-slug "tsgctf-2026" \
  --platform "ctfd" \
  --base-url "https://ctf.example.com" \
  --start-time "2026-04-01T00:00:00Z" \
  --end-time "2026-04-03T00:00:00Z" \
  --release-window "2026-04-01T12:00:00Z" \
  --submission-mode "print_only"
```

## AI-first usage pattern

1. You provide to AI:
   - platform URL
   - contest slug
   - start/end time
   - optional release windows
   - preferred submission mode
2. AI executes the script above.
3. AI starts orchestrator using that runtime config path.

## Runtime loop command

After Scrapling MCP writes normalized snapshot JSON (for example `./tsgctf-2026/runtime/latest-snapshot.json`), run:

```bash
ctf-orch-run \
  --config ./.agentsec/orchestrator/tsgctf-2026.yaml \
  --snapshot ./tsgctf-2026/runtime/latest-snapshot.json \
  --mode full
```

Then read `<contest>/runtime/dispatch-plan.json` to launch worker tasks.

Or use wrapper command:

```bash
ctf-orch-run \
  --config ./.agentsec/orchestrator/tsgctf-2026.yaml \
  --snapshot ./tsgctf-2026/runtime/latest-snapshot.json \
  --mode full
```

## Tunable flags

- `--submission-mode`: `print_only` or `auto_submit`
- `--max-concurrency`: capped at 3 by script policy
- `--release-window`: repeat this flag for multiple windows
- `--output`: optional custom path

## Security note

Credentials should still be supplied via environment variables:

- `CTF_USERNAME`
- `CTF_PASSWORD`
- `CTF_SESSION_TOKEN` (preferred for workers)

Do not store plaintext passwords inside generated YAML.
