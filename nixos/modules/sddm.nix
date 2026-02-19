{pkgs,...}:{

  services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      theme = "catppuccin-macchiato-ooo";
  };

  environment.systemPackages = [
    (pkgs.catppuccin-sddm.override
      {
        flavor = "macchiato";
        accent = "ooo";
        font = "Noto Sans";
        fontSize = "9";
        background = "${../../imgs/wallhaven_wqvwr6.jpg}";
        loginBackground = true;
      })
  ];
}