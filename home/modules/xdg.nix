{ ... }:
{
  xdg = {
    enable = true;
    desktopEntries = {
      typora = {
        name = "typora";
        exec = "typora --enable-features=UseOzonePlatform --ozone-platform=wayland --enable-wayland-ime";
        terminal = false;
      };
      android-studio-xcb-launcher = {
        name = "Android Studio (XCB Launcher)";
        exec = "android-studio-xcb-launcher";
        terminal = false;
        icon = "";
      };
    };
  };
}
