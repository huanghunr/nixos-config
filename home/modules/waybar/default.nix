{config,lib,inputs, ... }:
let
  mkSymlink = config.lib.file.mkOutOfStoreSymlink;
  confPath = "${config.home.homeDirectory}/nixos-config/home/modules/waybar/conf";
in
{
  xdg.configFile."waybar".source = mkSymlink "${confPath}";
}