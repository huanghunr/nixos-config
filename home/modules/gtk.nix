{ pkgs, lib, config, ... }:
{
  gtk = lib.mkIf (!config.programs.plasma_home.enable) {
    enable = true;
    theme = {
      name = "adw-gtk3";
      package = pkgs.adw-gtk3;
    };
    gtk3.extraConfig = {
      gtk-im-module = "fcitx";
    };
  };
}
