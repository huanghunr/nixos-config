{ pkgs, hyprland-plugins, ... }:
{
  # 回到 Home Manager 的 hyprland 模块（wayland.windowManager.hyprland）
  wayland.windowManager.hyprland = {
    enable = true;

    # 插件（通过 hyprland-plugins 提供的预构建二进制）
    plugins = [
      hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprbars
      hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprscrolling
      hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprtrails
      hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprexpo
    ];

    # 将同目录下的 hyprland.conf 合并为额外配置
    # 这样会写入到 ~/.config/hypr/hyprland.conf（由 HM 生成）中
    extraConfig = builtins.readFile ./hyprland.conf;
  };

  # 常用 Wayland 组件与工具
  home.packages = with pkgs; [
    # Bar & 通知 & 启动器
    waybar
    mako
    rofi-wayland

    # 终端与文件管理
    kitty
    ranger
    nemo

    # 锁屏
    swaylock-effects

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
  ];

  # 启用通知服务（mako）
  services.mako.enable = true;
}