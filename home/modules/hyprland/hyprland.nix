{
  pkgs,
  config,
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
  };
  services.polkit-gnome.enable = true; # polkit

    # 常用 Wayland 组件与工具
  home.packages = with pkgs; [
    # Bar & 通知 & 启动器
    waybar

    # 终端与文件管理
    kitty

    # 多媒体创作
    obs-studio
    
    playerctl

    brightnessctl

    foot

  ];
}
