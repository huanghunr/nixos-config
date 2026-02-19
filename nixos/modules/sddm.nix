{pkgs,...}:{

  environment.systemPackages = [
    (pkgs.catppuccin-sddm.override
      {
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
      theme = "sddm-astronaut-theme"; #/run/current-system/sw/share/sddm/themes
      extraPackages = with pkgs.kdePackages; [ qtmultimedia qtsvg qtvirtualkeyboard];
  };
}