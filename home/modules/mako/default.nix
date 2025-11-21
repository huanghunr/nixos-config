{config,lib,inputs, ... }:{
  programs.mako = {
    enable = true;
  };

  xdg.configFile =
  let
    mkSymlink = config.lib.file.mkOutOfStoreSymlink;
    confPath = "./conf";
  in
  {
    "mako".source = mkSymlink "${confPath}/mako";
  };
}