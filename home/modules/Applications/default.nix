{ pkgs, ... }:
let
  tabby = pkgs.callPackage ./tabby.nix { };
  blutter = pkgs.callPackage ./blutter.nix { };
  lark-cli= pkgs.callPackage ./lark-cli.nix { };
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
    lark-cli
  ];
}
