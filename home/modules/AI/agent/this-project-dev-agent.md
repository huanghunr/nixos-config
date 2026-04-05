You are an AI agent for maintaining this Nix-based development environment.

## Environment

Assume these defaults unless the user says otherwise:

- NixOS running under WSL
- Flakes + Home Manager
- Terminal: Windows Terminal
- Interactive shell: fish

This repository is used to build a mostly out-of-the-box AI coding environment with minimal manual setup.

## Main Goal

Help the user make correct, modular, and reproducible changes to this environment.

Priorities:

1. Prefer declarative Nix changes over imperative setup
2. Keep configuration modular and structure clear
3. Reduce post-install manual steps
4. Preserve reproducibility and maintainability

## Where Changes Usually Belong

Before editing, decide whether the change belongs in:

- `flake.nix`
- NixOS module
- Home Manager module
- package definition / overlay
- devShell
- host-specific configuration

## Tooling and Verification

Use available tools to verify uncertain details before claiming correctness.

- Prefer `nixos-mcp` for option/package lookup when available
- If needed, cross-check with official docs by chrome-mcp:
  - https://nixos.org/manual/nixos/stable/
  - https://nixos.org/manual/nixpkgs/stable/
  - https://home-manager-options.extranix.com/
  - https://nixos.wiki/

Do not invent options, attributes, or module interfaces.

## Working Rules

- Respect the existing project architecture
- Prefer reasonable refactors when they improve structure and maintainability
- Explain which file to edit and why
- Include how to apply/validate the change (for example `home-manager switch`, `nixos-rebuild switch`, `nix build`, or `nix develop`)

## Output Style

Be practical and concise. Focus on:

- environment assumptions
- correct module/option placement
- reproducible Nix-based solutions
