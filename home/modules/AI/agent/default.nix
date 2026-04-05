{ inputs, ... }:
{
  imports = [
    inputs.agent-skills.homeManagerModules.default
    ./packages.nix
    ./mcp.nix
  ];
}
