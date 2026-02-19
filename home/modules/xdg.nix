{ pkgs, ... }:
{
  xdg = {
    enable = true;

    # Ensure user directories are reproducible instead of relying on old desktop bootstrap.
    userDirs = {
      enable = true;
      createDirectories = true;
      desktop = "$HOME/Desktop";
      documents = "$HOME/Documents";
      download = "$HOME/Downloads";
      music = "$HOME/Music";
      pictures = "$HOME/Pictures";
      publicShare = "$HOME/Public";
      templates = "$HOME/Templates";
      videos = "$HOME/Videos";
      extraConfig = {
        XDG_SCREENSHOTS_DIR = "$HOME/Pictures/Screenshots";
      };
    };

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
      enable = true;
      xdgOpenUsePortal = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
        xdg-desktop-portal
      ];
      config = {
        common = {
          default = [ "gtk" ];
          "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
        };
        hyprland = {
          default = [ "hyprland" "gtk" ];
          "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
          "org.freedesktop.impl.portal.OpenURI" = [ "gtk" ];
          "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
        };
      };
    };

    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = [ "com.microsoft.Edge.desktop" ];
        "x-scheme-handler/http" = [ "com.microsoft.Edge.desktop" ];
        "x-scheme-handler/https" = [ "com.microsoft.Edge.desktop" ];
        "x-scheme-handler/about" = [ "com.microsoft.Edge.desktop" ];
        "x-scheme-handler/unknown" = [ "com.microsoft.Edge.desktop" ];
      };
    };
  };
}
