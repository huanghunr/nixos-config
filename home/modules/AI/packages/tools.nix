{ pkgs, inputs, ... }:
let
  pwno-up = pkgs.callPackage ./pwno-up.nix { };
  idalib-up = pkgs.callPackage ./idalib-up.nix { };
in
{
  home.packages = [
    pwno-up
    idalib-up
  ];
}
