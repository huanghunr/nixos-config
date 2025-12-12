{pkgs,...}:
let
  clipboard_sync = pkgs.callPackage ./clipboard_sync.nix {};
  android_studio_xcb_launcher = pkgs.callPackage ./android-studio-xcb-launcher.nix {};
in
{
  home.packages = [
    clipboard_sync
    android_studio_xcb_launcher
  ];
}