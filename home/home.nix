{
  pkgs,
  ...
}:

{
  # user info
  home.username = "huanghunr";
  home.homeDirectory = "/home/huanghunr";

  imports = [
    ./modules/neovim
    ./modules/hyprland
    ./modules/yazi.nix
    ./modules/zellij.nix
    ./modules/Noctalia
    ./modules/gtk.nix
    ./modules/kitty
    ./modules/xdg.nix
    ./modules/dev
    ./modules/ssh.nix
    ./modules/fish.nix
    ./modules/vscode.nix
    ./modules/Applications

    ./script
  ];

  # DPI and Xresources
  xresources.properties = {
    "Xcursor.size" = 16;
    "Xft.dpi" = 172;
  };
  programs.local-ida.enable = true;

  programs.yesplaymusic.enable = true;

  home.packages = with pkgs; [
    netease-cloud-music-gtk
    tree
    wechat
    microsoft-edge
    p7zip
    unrar
    anyrun
    nwg-look # gtk theme switcher
    mpv
    qqmusic
    typora
    thunderbird
    baidupcs-go
    speedtest-cli
    xorg.xwininfo
    hmcl
    gimp-with-plugins
    duckdb
    libreoffice-qt
  ];

  # git
  programs.git = {
    enable = true;
    settings = {
      user.name = "huanghunr";
      user.email = "huanghunr@outlook.com";
      gpg = {
        format = "ssh";
      };
    };
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
