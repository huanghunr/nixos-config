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
    mako
    rofi-wayland

    # 终端与文件管理
    kitty

    # 锁屏
    swaylock

    # 截图/录屏/剪贴板
    grimblast
    wf-recorder
    wl-clipboard

    # 媒体与图像
    mpv
    imv

    # 其他常用 Wayland 工具
    hyprshot
    swaybg
    hyprpicker
    wlogout

    # 桌面图标主题
    papirus-icon-theme

    # 多媒体创作
    obs-studio
    playerctl

    brightnessctl
  ];
}
