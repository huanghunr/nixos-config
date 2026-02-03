{ pkgs, inputs, ... }:
let
  unstable = inputs.unstablepkgs.legacyPackages.${pkgs.system};
in
{
  home.packages = [
    unstable.opencode
  ];
}
