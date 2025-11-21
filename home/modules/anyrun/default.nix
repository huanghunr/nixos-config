{config,lib,inputs, ... }:
let
  mkSymlink = config.lib.file.mkOutOfStoreSymlink;
  confPath = "${config.home.homeDirectory}/nixos-config/home/modules/anyrun/conf";
in
{
  xdg.configFile."anyrun".source = mkSymlink "${confPath}";
}