{ pkgs, ... }:

pkgs.writeShellScriptBin "pwno-up" ''
  #!/usr/bin/env bash
  set -euo pipefail

  podman run --rm -p 5500:5500 \
    --cap-add=SYS_PTRACE \
    --cap-add=SYS_ADMIN \
    --security-opt seccomp=unconfined \
    --security-opt apparmor=unconfined \
    -v "$PWD/workspace:/workspace" \
    ghcr.io/pwno-io/pwno-mcp:latest
''
