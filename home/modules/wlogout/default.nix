{config,lib,inputs, ... }:
let
  mkSymlink = config.lib.file.mkOutOfStoreSymlink;
  confPath = "${config.home.homeDirectory}/nixos-config/home/modules/wlogout/conf";
in
{
  xdg.configFile."wlogout".source = mkSymlink "${confPath}";
}