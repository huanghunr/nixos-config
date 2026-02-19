{
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/nvidia.nix
    ./modules/bluetooth.nix
    ./modules/nix-ld.nix
    ./modules/nixRuntime.nix
    ./modules/ssh.nix
    ./modules/secrets.nix
    ./modules/frp.nix
    ./modules/podman.nix
    ./modules/virtualbox.nix
    ./modules/flatpak.nix
    ./modules/sddm.nix
  ];

  modules = {
    my-frp.enable = false;
  };

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_zen;
  };

  networking = {
    hostName = "nixos"; # hostname.
    proxy.default = "http://127.0.0.1:7897/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
    networkmanager.enable = true;

    firewall = {
      allowedTCPPorts = [ 6000 ];
      # allowedUDPPorts = [ ... ];
    };
  };

  # time zone.
  time = {
    timeZone = "Asia/Shanghai";
    hardwareClockInLocalTime = false;
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [
      "zh_CN.UTF-8/UTF-8"
      "en_US.UTF-8/UTF-8"
    ];

    extraLocaleSettings = {
      LC_ADDRESS = "zh_CN.UTF-8";
      LC_IDENTIFICATION = "zh_CN.UTF-8";
      LC_MEASUREMENT = "zh_CN.UTF-8";
      LC_MONETARY = "zh_CN.UTF-8";
      LC_NAME = "zh_CN.UTF-8";
      LC_NUMERIC = "zh_CN.UTF-8";
      LC_PAPER = "zh_CN.UTF-8";
      LC_TELEPHONE = "zh_CN.UTF-8";
      LC_TIME = "zh_CN.UTF-8";
    };

    inputMethod = {
      type = "fcitx5";
      enable = true;
      fcitx5.waylandFrontend = true;
      fcitx5.addons = with pkgs; [
        fcitx5-rime
        qt6Packages.fcitx5-chinese-addons
        fcitx5-nord # a color theme
        fcitx5-mozc
        fcitx5-gtk
        rime-zhwiki
      ];
    };
  };

  fonts.packages = with pkgs; [
    adwaita-fonts
    material-design-icons
    noto-fonts-color-emoji
    nerd-fonts.symbols-only
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.iosevka
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    wqy_microhei
    wqy_zenhei
  ];

  services = {
    xserver = {
      enable = true;
      # Configure keymap in X11
      xkb = {
        layout = "us";
        variant = "";
      };
    };

    desktopManager.plasma6.enable = false; # if use Plasma desktop

    printing.enable = true; # Enable CUPS to print documents.

    pulseaudio.enable = false;
    pipewire = {
      # Enable sound with pipewire.
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };

    libinput = {
      enable = true; # Enable touchpad support (enabled default in most desktopManager).
      touchpad.tapping = true;
    };

    power-profiles-daemon.enable = true;
    upower.enable = true;
    supergfxd.enable = true;

    asusd = {
      enable = true;
      enableUserService = true;
    };

    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    # mihomo= {
    #   enable = true;
    #   tunMode = true;
    # };
  };

  security = {
    rtkit.enable = true;
    polkit.enable = true;
    sudo.extraConfig = ''
      # envs to be preserved when using sudo
          Defaults env_keep += "http_proxy https_proxy"
    '';
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.huanghunr = {
    isNormalUser = true;
    description = "huanghunr";
    extraGroups = [
      "networkmanager"
      "wheel"
      "adbusers"
      "kvm"
      "libvirtd"
    ];
    shell = pkgs.fish; # defult shell to fish
    packages = with pkgs; [
      kdePackages.kate
    ];
  };

  programs = {
    dconf.enable = true;
    firefox.enable = true;
    clash-verge = {
      enable = true;
      tunMode = true;
    };
    uwsm.enable = true;
    fish = {
      enable = true;
    };
    hyprland = {
      enable = true;
      withUWSM = true; # recommended for most users
      xwayland.enable = true; # Xwayland can be disabled.
    };
    direnv.enable = true;
    adb.enable = true;

  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  environment = {
    systemPackages = [
      pkgs.git
      pkgs.vim
      pkgs.wget
      pkgs.lshw
      pkgs.btop
      pkgs.intel-gpu-tools
      pkgs.xorg.libXrandr
      pkgs.xorg.libXrender
      pkgs.xorg.libXi
      pkgs.xorg.libXcursor
      pkgs.xdg-utils
      pkgs.xorg.libX11
      pkgs.xorg.libxcb
      pkgs.xorg.xwininfo
      pkgs.libdrm
      pkgs.libGL
      pkgs.krb5
      pkgs.kitty
      pkgs.wl-clipboard
      pkgs.asus-wmi-screenpad-ctl
      pkgs.nix-index
      pkgs.libxcb-cursor
    ];

    sessionVariables.NIXOS_OZONE_WL = "1";
    sessionVariables.QT_QPA_PLATFORMTHEME = "qt5ct";

    variables = {
      EDITOR = "vim";
      XMODIFIERS = "@im=fcitx";
      QT_IM_MODULES = "wayland;fcitx";
      QT_IM_MODULE = "fcitx";
      HYPRSHOT_DIR = "$HOME/Pictures/Screenshots";
      QT_QPA_PLATFORM = "wayland";
      _JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=lcd";
    };
  };

  qt = {
    enable = true;
    platformTheme = "qt5ct";
    style = "kvantum";
  };

  system.stateVersion = "25.05";
}
