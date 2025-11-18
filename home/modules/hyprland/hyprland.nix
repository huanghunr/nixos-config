{ pkgs, hyprland, hyprland-plugins, ... }:
{
  # 采用 upstream Hyprland Home Manager 模块的 programs.hyprland 语义
  # flake.nix 已导入 hyprland.homeManagerModules.default
  programs.hyprland = {
    enable = true; # 用户层 declarative 配置
    # 插件列表（使用 upstream hyprland-plugins flake 构建的二进制）
    plugins = [
      hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprbars
      hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprscrolling
      hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprtrails
      hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprexpo
    ];
    settings = {
      "$mod" = "SUPER";
      decoration = {
        shadow_offset = "0 5";
        "col.shadow" = "rgba(00000099)";
      };

      # 鼠标拖拽/调整窗口快捷方式
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
        "$mod ALT, mouse:272, resizewindow"
      ];
    };
  };

  # 常用 Wayland 组件与工具
  home.packages = with pkgs; [
    waybar      # 状态栏
    mako        # 通知
    hyprshot    # 截图
    swaybg      # 壁纸
    hyprpicker  # 取色器
    wlogout     # 登出界面
    swaylock    # 锁屏（可替换为 hyprlock）
  ];
}