{ pkgs, ... }:
let
  tabby = pkgs.callPackage ./tabby.nix { };
  blutter = pkgs.callPackage ./blutter.nix { };
in
{
  imports = [
    ./ida.nix
    ./yesplaymusic.nix
    ./BinaryNinja.nix
  ];
  
  home.packages = [
    tabby
    blutter
  ];
}
