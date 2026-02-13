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
    ./modules/dev
    ./modules/kitty
    ./modules/AI
    ./modules/hyprland
    ./modules/Noctalia
    ./modules/Applications
    ./modules/Applications/securityTools

    ./modules/yazi.nix
    ./modules/zellij.nix
    ./modules/gtk.nix
    ./modules/xdg.nix
    ./modules/ssh.nix
    ./modules/fish.nix
    ./modules/vscode.nix

    ./script
  ];

  # DPI and Xresources
  xresources.properties = {
    "Xcursor.size" = 16;
    "Xft.dpi" = 172;
  };

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

    hmcl
    gimp-with-plugins
    duckdb
    libreoffice-qt
    sops
    motrix
    wemeet
    file
    rustdesk
    qq
    kitty
    obs-studio
    fastfetch

    man
    man-pages
    man-pages-posix
  ];

  programs = {
    # local programs
    local-ida.enable = true;
    yesplaymusic.enable = true;

    git = {
      enable = true;
      settings = {
        user.name = "huanghunr";
        user.email = "huanghunr@outlook.com";
        gpg = {
          format = "ssh";
        };
      };
    };

    starship = {
      enable = true;
      settings = {
        add_newline = false;
        aws.disabled = true;
        gcloud.disabled = true;
        line_break.disabled = true;
      };
    };

  };

  home.stateVersion = "25.05";
}
