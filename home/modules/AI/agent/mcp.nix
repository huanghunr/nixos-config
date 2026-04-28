{ pkgs, inputs, ... }:
let
  mcpPython = pkgs.callPackage ./../../dev/python.nix { inherit pkgs inputs; };
  playwrightLibPath = pkgs.lib.makeLibraryPath [
    pkgs.stdenv.cc.cc
    pkgs.glib
    pkgs.nspr
    pkgs.nss
    pkgs.dbus
    pkgs.atk
    pkgs.at-spi2-atk
    pkgs.cups
    pkgs.expat
    pkgs.libxkbcommon
    pkgs.libxcb
    pkgs.xorg.libX11
    pkgs.xorg.libXcomposite
    pkgs.xorg.libXdamage
    pkgs.xorg.libXext
    pkgs.xorg.libXfixes
    pkgs.xorg.libXrandr
    pkgs.libdrm
    pkgs.libgbm
    pkgs.mesa
    pkgs.cairo
    pkgs.pango
    pkgs.alsa-lib
    pkgs.systemd
  ];
  scraplingMcpServer = pkgs.writeShellScriptBin "scrapling-mcp-server" ''
    set -euo pipefail
    export PLAYWRIGHT_BROWSERS_PATH="''${XDG_CACHE_HOME:-$HOME/.cache}/ms-playwright"
    mkdir -p "$PLAYWRIGHT_BROWSERS_PATH"
    if ! ls "$PLAYWRIGHT_BROWSERS_PATH"/chromium-* >/dev/null 2>&1; then
      "${mcpPython.py-exec}" -m patchright install chromium
    fi
    export PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS=1
    export LD_LIBRARY_PATH="${playwrightLibPath}:''${LD_LIBRARY_PATH:-}"
    exec "${mcpPython.py-bin}/scrapling" mcp "$@"
  '';
  bootstrapRuntimeConfig = pkgs.writeShellScriptBin "ctf-orch-bootstrap" ''
    set -euo pipefail
    exec "${mcpPython.py-exec}" "${./orchestrator/scripts/bootstrap_runtime_config.py}" "$@"
  '';
  runOrchestratorRuntime = pkgs.writeShellScriptBin "ctf-orch-run" ''
    set -euo pipefail
    exec "${mcpPython.py-exec}" "${./orchestrator/scripts/orchestrator_runtime.py}" "$@"
  '';
  mcpSettings = {
    # ida-pro-mcp = {
    #   command = "${mcpPython.py-exec}";
    #   args = [
    #     "${mcpPython.py-site-pkgs}/ida_pro_mcp/server.py"
    #     "--ida-rpc"
    #     "http://127.0.0.1:13337"
    #   ];
    # };

    idalib-mcp = {
      enable = true;
      type = "remote";
      url = "http://127.0.0.1:8745/mcp";
    };

    mcp-nixos = {
      command = "nix";
      args = [
        "run"
        "github:utensils/mcp-nixos"
        "--"
      ];
    };

    pwno-mcp = {
      enable = false;
      type = "remote";
      url = "http://127.0.0.1:5500/mcp";
    };

    chrome-devtools = {
      command = "npx";
      args = [
        "-y"
        "chrome-devtools-mcp@latest"
        "--executablePath=${pkgs.google-chrome}/bin/google-chrome-stable"
        "--headless"
        "--chromeArg='--no-sandbox'"
        "--chromeArg='--disable-dev-shm-usage'"
        "--logFile /tmp/chrome-devtools-mcp.log"
      ];
    };

    scrapling-mcp = {
      enable = false;
      command = "${scraplingMcpServer}/bin/scrapling-mcp-server";
      args = [ ];
    };

    mcp_windbg_http = {
      enable = false;
      type = "remote"; # start in windows by "mcp-windbg --transport streamable-http --host 127.0.0.1 --port 8000"
      url = "http://127.0.0.1:8000/mcp";
    };
  };
in
{
  home.packages = [
    mcpPython.mcpPython
    scraplingMcpServer
    bootstrapRuntimeConfig
    runOrchestratorRuntime
  ];
  home.file.".local/mcp/mcpPython".source = "${mcpPython.mcpPython}";

  programs.mcp = {
    enable = true;
    servers = mcpSettings;
  };
}
