{config,lib,inputs, ... }:
let
  mkSymlink = config.lib.file.mkOutOfStoreSymlink;
  confPath = "${config.home.homeDirectory}/nixos-config/home/modules/mako/conf";
in
{
  xdg.configFile."mako".source = mkSymlink "${confPath}";
}