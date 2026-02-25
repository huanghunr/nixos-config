{ pkgs, ... }:
let
  tabby = pkgs.callPackage ./tabby.nix {};
in
{
  imports = [
    ./ida.nix
    ./yesplaymusic.nix
  ];
  home.packages = [ tabby ];
}