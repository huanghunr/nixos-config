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
      enable = true;
    };
    plugins = [
      inputs.hyprgrass.packages.${pkgs.system}.default

      # optional integration with pulse-audio, see examples/hyprgrass-pulse/README.md
      inputs.hyprgrass.packages.${pkgs.system}.hyprgrass-pulse
   ];
    portalPackage = null;
  };
  services.polkit-gnome.enable = true; # polkit
  
  # 常用 Wayland 组件与工具
  home.packages = with pkgs; [
    # 终端与文件管理
    kitty

    # 多媒体创作
    obs-studio

    playerctl

    brightnessctl

    foot

    hyprshot

    grim

    slurp

    gradia
  ];
}
