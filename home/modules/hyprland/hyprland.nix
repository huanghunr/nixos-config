{
  pkgs,
  inputs,
  ...
}:
let
  package = pkgs.hyprland;
in
{

  wayland.windowManager.hyprland = {
    inherit package;
    enable = true;
    systemd = {
      enable = false; #Warning: If you use the Home Manager module, make sure to disable systemd integration, as it conflicts with UWSM.
    };
    plugins = [
      inputs.hyprgrass.packages.${pkgs.system}.default
      inputs.hyprgrass.packages.${pkgs.system}.hyprgrass-pulse
   ];
    portalPackage = null; # preventing conflicts with hyprland programs
  };
  services.polkit-gnome.enable = true; # polkit
  
  home.packages = with pkgs; [

    playerctl

    brightnessctl

    foot

    hyprshot

    grim

    slurp

    gradia

    cliphist
  ];
}
