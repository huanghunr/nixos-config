{pkgs,...}:
let
  clipboard_sync = pkgs.callPackage ./clipboard_sync.nix {};
in
{
  home.packages = [
    clipboard_sync
  ];
}