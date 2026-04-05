{ pkgs, ... }:

pkgs.writeShellScriptBin "idalib-up" ''
    set -euo pipefail

    HOST="''${IDALIB_MCP_HOST:-127.0.0.1}"
    PORT="''${IDALIB_MCP_PORT:-8745}"

    show_help() {
      cat <<EOF
  idalib-up - start idalib-mcp with isolated contexts

  Usage:
    idalib-up <path-to-executable> [extra-args...]
    idalib-up --help

  Example:
    idalib-up /path/to/executable

  Equivalent command:
    uv run idalib-mcp --isolated-contexts --host ''${HOST} --port ''${PORT} <path-to-executable>

  Why --isolated-contexts?
    Use it when multiple agents connect to the same idalib-mcp server and you want
    deterministic context isolation:

    - Prevent one agent from changing another agent's active session accidentally.
    - Run concurrent analyses safely (for example agent A on binary X and agent B on binary Y).
    - Still allow intentional collaboration by binding multiple agents to the same open session ID.
    - Improve reproducibility because each agent's context binding is explicit.

  Behavior when --isolated-contexts is enabled:
    - Each transport context has its own binding:
        * Mcp-Session-Id for /mcp
        * session for /sse
        * stdio:default for stdio
    - Unbound contexts fail fast for IDB-dependent tools/resources.
    - idalib_switch(session_id) and idalib_open(...) bind the caller context only.

  Default listen address:
    host: ''${HOST}
    port: ''${PORT}

  Environment overrides:
    IDALIB_MCP_HOST   Override listen host
    IDALIB_MCP_PORT   Override listen port

  Notes:
    - You must provide the target executable path.
    - Extra arguments after the executable path are passed through to idalib-mcp.
  EOF
    }

    if [[ "''${1:-}" == "--help" || "''${1:-}" == "-h" ]]; then
      show_help
      exit 0
    fi

    if [[ $# -lt 1 ]]; then
      echo "Error: missing path-to-executable" >&2
      echo >&2
      show_help >&2
      exit 1
    fi

    TARGET="$1"
    shift

    exec uv run idalib-mcp \
      --isolated-contexts \
      --host "''${HOST}" \
      --port "''${PORT}" \
      "''${TARGET}" \
      "$@"
''
