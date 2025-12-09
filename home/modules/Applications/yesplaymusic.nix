{
  config,
  lib,
  pkgs,
  ...
}:

let
  mainPath = "${config.home.homeDirectory}/Applications/yesplaymusic/squashfs-root";
  binaryPath = "${mainPath}/resources/app.asar";
  iconPath = "${mainPath}/yesplaymusic.png";

  name = "YesPlayMusic";
  genericName = "Music Player";
  icon = iconPath;
  categories = [
    "Player"
    "Music"];
  mimeType = [
    "application/x-executable"
    "application/octet-stream"
  ];

  # 检测文件是否存在
  hasBinary = builtins.pathExists binaryPath;

in
{
  options.programs.yesplaymusic = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = hasBinary;
      description = "Enable local installation of yesplaymusic.";
    };
  };

  config = lib.mkIf config.programs.yesplaymusic.enable {
    xdg.desktopEntries.ida = {
      exec = "electron ${binaryPath} --enable-features=UseOzonePlatform --ozone-platform=wayland --enable-wayland-ime ";
      terminal = false;
      inherit name genericName icon categories mimeType;
    };
  };
}
