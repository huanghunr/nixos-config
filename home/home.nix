{ config, pkgs, inputs, ... }:

{
  # user info
  home.username = "huanghunr";
  home.homeDirectory = "/home/huanghunr";

  imports = [
    ./modules/neovim
    ./modules/dev/packages.nix
    ./modules/hyprland
    ./modules/yazi.nix
    ./modules/zellij.nix
    ./modules/Noctalia
    ./modules/gtk.nix
    ./modules/kitty
  ];

  # DPI and Xresources
  xresources.properties = {
    "Xcursor.size" = 16;
    "Xft.dpi" = 172;
  };

  home.packages = with pkgs; [
    netease-cloud-music-gtk
    vscode-fhs
    tree
    wechat
    microsoft-edge
    p7zip
    unrar
    anyrun
    nwg-look #gtk theme switcher
    qcm
    mpv
    qqmusic
    typora
    thunderbird
    baidupcs-go
    speedtest-cli
  ];

  # git
  programs.git = {
    enable = true;
    userName = "huanghunr";
    userEmail = "huanghunr@outlook.com";
  };

  # starship
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      aws.disabled = true;
      gcloud.disabled = true;
      line_break.disabled = true;
    };
  };

  # alacritty
  programs.alacritty = {
    enable = true;
    settings = {
      env.TERM = "xterm-256color";
      font = {
        size = 12;
        draw_bold_text_with_bright_colors = true;
      };
      scrolling.multiplier = 5;
      selection.save_to_clipboard = true;
    };
  };

  # changes in each release.
  home.stateVersion = "25.05";
}