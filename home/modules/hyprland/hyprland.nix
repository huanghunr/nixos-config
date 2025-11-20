{
  pkgs,
  config,
  ...
}:
let
  package = pkgs.hyprland;
in
{
  xdg.configFile =
    let
      mkSymlink = config.lib.file.mkOutOfStoreSymlink;
      confPath = "${config.home.homeDirectory}/nixos-config/home/modules/hyprland/conf";
    in
    {
      "hypr/configs".source = mkSymlink confPath;
    };

  # NOTE:
  # We have to enable hyprland/i3's systemd user service in home-manager,
  # so that gammastep/wallpaper-switcher's user service can be start correctly!
  # they are all depending on hyprland/i3's user graphical-session
  wayland.windowManager.hyprland = {
    inherit package;
    enable = true;
    settings = {
      source =
        let
          configPath = "${config.home.homeDirectory}/.config/hypr/configs";
        in
        [
          "${configPath}/exec.conf"
          "${configPath}/fcitx5.conf"
          "${configPath}/keybindings.conf"
          "${configPath}/settings.conf"
          "${configPath}/windowrules.conf"
        ];
      env = [

      ];
    };
    # gammastep/wallpaper-switcher need this to be enabled.
    systemd = {
      enable = true;
    };
  };
  services.polkit-gnome.enable = true; # polkit

  # NOTE: this executable is used by greetd to start a wayland session when system boot up
  # with such a vendor-no-locking script, we can switch to another wayland compositor without modifying greetd's config in NixOS module
  # home.file.".wayland-session" = {
  #   source = "${package}/bin/Hyprland";
  #   executable = true;
  # };
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
