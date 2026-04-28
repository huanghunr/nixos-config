{ pkgs, inputs, upkgs, ... }:
{
  home.packages = [
  ];

  programs = {
    agent-skills = {
      enable = true;

      sources.ctf = {
        path = inputs.ctf-skills;
        subdir = ".";
      };

      sources.awesome-claude-skills = {
        path = inputs.awesome-claude-skills;
        subdir = ".";
      };

      skills.enable = [
        # "solve-challenge"
        # "ctf-web"
        # "ctf-pwn"
        # "ctf-crypto"
        # "ctf-reverse"
        # "ctf-forensics"
        # "ctf-osint"
        # "ctf-malware"
        # "ctf-misc"

        "mcp-builder"
        "skill-creator"
      ];

      targets.opencode = {
        enable = true;
        dest = "$HOME/.config/opencode/skill";
        structure = "symlink-tree";
      };
    };

    opencode = {
      enable = true;
      enableMcpIntegration = true;
      package = upkgs.opencode;
      settings = {
        theme = "system";
        provider = {
          codex-manager= {
            npm = "@ai-sdk/openai-compatible";
            name = "9router";
            options= {
              baseURL= "http://127.0.0.1:20128/v1";
              apiKey= "{file:/run/secrets/9ROUTER_API_KEY}";
            };
            models= {
              "cx/gpt-5.4" = {};
              "cx/gpt-5.3-codex-xhigh" = {};
              "cx/gpt-5.3-codex" = {};
            };
          };
        };
      };
      agents = {
        ctf-master-agent = ./ctf-master-agent.md;
        ctf-worker-agent = ./ctf-worker-agent.md;
        security-agent = ./security-agent.md;
        nixos-agent = ./this-project-dev-agent.md;
      };
    };

    # codex = {
    #   enable = true;
    #   package = unstable.codex;
    # };

    # claude-code = {
    #   enable = true;
    #   package = unstable.claude-code;
    # };
  };

}
