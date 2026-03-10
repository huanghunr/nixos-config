{ pkgs, config, ... }:
{
#   systemd.services.display-manager.environment = {
#     QT_QUICK_CONTROLS_STYLE = "org.kde.desktop";
#   }; #using this environment variable will cause plasma to launch a black screen due to module conflicts

  environment.systemPackages = [
    (pkgs.catppuccin-sddm.override {
      flavor = "macchiato";
      accent = "rosewater";
      font = "Noto Sans";
      fontSize = "9";
      background = "${../../imgs/wallhaven_wqvwr6.jpg}";
      loginBackground = false;
    })
    (pkgs.sddm-astronaut.override {
      embeddedTheme = "hyprland_kath";
      themeConfig = {
        Background = "${../../imgs/wallhaven_wqvwr6.jpg}";
        BackgroundPlaceholder = "";
        BackgroundSpeed = "";
      };
    })
  ];

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    wayland.compositor = pkgs.lib.mkOptionDefault "kwin";
    theme = "breeze"; # /run/current-system/sw/share/sddm/themes
    extraPackages = with pkgs.kdePackages; [
      qtmultimedia
      qtsvg
      qtvirtualkeyboard
      kirigami
    ];
  };
}
