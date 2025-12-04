{ ... }:
{
  xdg = {
    enable = true;
    desktopEntries = {
      typora = {
        name = "typora";
        exec = "typora --enable-features=UseOzonePlatform --ozone-platform=wayland";
        terminal = false;
      };
    };
  };
}
