{ pkgs, inputs, upkgs, ... }:
{
  home.packages = [
  ];

  programs = {
    agent-skills = {
      enable = true;

      sources.local-skills = {
        path = inputs.local-skills;
        subdir = ".";
        idPrefix = "local";
      };

      sources.awesome-claude-skills = {
        path = inputs.awesome-claude-skills;
        subdir = ".";
      };

      sources.awesome-copilot-skills = {
        path = inputs.awesome-copilot-skills;
        idPrefix = "gh";
        subdir = "skills";
      };

      sources.feishu-skills = {
        path = inputs.feishu-cli;
        subdir = "skills";
        idPrefix = "feishu";
      };
      
      sources.as0ler-skills = {
        path = inputs.as0ler-skills;
        subdir = ".";
        idPrefix = "as0ler";
      };

      skills.enable = [
        # "solve-challenge"
        "local/ctf-web"
        "local/ctf-pwn"
        "local/ctf-crypto"
        "local/ctf-reverse"
        "local/ctf-forensics"
        "local/ctf-osint"
        "local/ctf-malware"
        "local/ctf-misc"
        "local/ctf-ai-ml"
        "local/nixos-local"

        "feishu/lark-im"
        "feishu/lark-shared"

        "as0ler/frida"
        # "as0ler/radare2"

        "gh/gh-cli"

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
