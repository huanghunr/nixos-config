{ pkgs, hyprland-plugins, ... }:
{
  # 回到 Home Manager 的 hyprland 模块（wayland.windowManager.hyprland）
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      decoration = {
        shadow_offset = "0 5";
        "col.shadow" = "rgba(00000099)";
      };

      "$mod" = "SUPER";

      # 鼠标拖拽/调整窗口快捷方式
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
        "$mod ALT, mouse:272, resizewindow"
      ];
    };

    # 插件（通过 hyprland-plugins 提供的预构建二进制）
    plugins = [
      hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprbars
      hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprscrolling
      hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprtrails
      hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprexpo
    ];
  };

  # 常用 Wayland 组件与工具
  home.packages = with pkgs; [
    waybar
    mako
    hyprshot
    swaybg
    hyprpicker
    wlogout
    swaylock
  ];
}