{ pkgs, ... }:

pkgs.writeShellScriptBin "lark-cli" ''
  #!/usr/bin/env bash
  feishu-cli "$@"
''