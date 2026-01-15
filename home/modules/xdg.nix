{ pkgs, ... }:
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
    portal = {
      xdgOpenUsePortal = true;
      extraPortals = with pkgs; [ xdg-desktop-portal-gtk xdg-desktop-portal ];
      # config = {
      #   common = {
      #     default = [ "gtk" ];
      #     "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
      #   };
      #   hyprland = {
      #     default = [ "hyprland" "gtk" ];
      #     "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
      #     "org.freedesktop.impl.portal.OpenURI" = [ "gtk" ];
      #   };
      # };
    };
    # mimeApps = {
    #   defaultApplications = {
    #     "text/html" = [ "com.microsoft.Edge.desktop" ];
    #     "x-scheme-handler/http"  = [ "firefox.desktop" ];
    #     "x-scheme-handler/https" = [ "com.microsoft.Edge.desktop" ];
    #   };
    # };
  };

}
