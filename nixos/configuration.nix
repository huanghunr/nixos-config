{
  pkgs,
  ...
}:

{
  #hardware
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
  ];

  modules.my-frp.enable = false;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_zen;

  networking.hostName = "nixos"; # hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  networking.proxy.default = "http://127.0.0.1:7897/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";
  time.hardwareClockInLocalTime = false;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = [
    "zh_CN.UTF-8/UTF-8"
    "en_US.UTF-8/UTF-8"
  ];

  i18n.extraLocaleSettings = {
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

  # Simplified Chinese:
  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      fcitx5-rime # alternatively, kdePackages.fcitx5-qt
      qt6Packages.fcitx5-chinese-addons # table input method support
      fcitx5-nord # a color theme
      fcitx5-mozc
      fcitx5-gtk
      rime-zhwiki
    ];
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

  # SDDM
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true; # if use Plasma desktop

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;
  # services.mihomo= {
  #   enable = true;
  #   tunMode = true;
  # };

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  security.polkit.enable = true;
  services.pipewire = {
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

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput = {
    enable = true;
    touchpad.tapping = true;
  };

  services.power-profiles-daemon.enable = true;

  services.upower.enable = true;

  services.supergfxd.enable = true;

  services = {
    asusd = {
      enable = true;
      enableUserService = true;
    };
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
    packages = with pkgs; [
      kdePackages.kate
    ];
  };
  
  programs.dconf.enable = true;

  # Install programs.
  programs = {
    firefox.enable = true;
    clash-verge={
      enable = true;
      tunMode = true;
    };
    uwsm.enable = true;
  };

  programs.fish = {
    enable = true;
  };

  # hyprland
  programs.hyprland = {
    enable = true;
    withUWSM = true; # recommended for most users
    xwayland.enable = true; # Xwayland can be disabled.
  };

  programs.direnv.enable = true;

  programs.adb.enable = true;

  # defult shell to fish
  users.users.huanghunr.shell = pkgs.fish;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  environment.systemPackages = [
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
    pkgs.libdrm
    pkgs.libGL
    pkgs.krb5
    pkgs.qq
    pkgs.kitty
    pkgs.wl-clipboard
    pkgs.asus-wmi-screenpad-ctl
    pkgs.nix-index
    pkgs.libxcb-cursor
  ];

  qt = {
    enable = true;
    platformTheme = "qt5ct";
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.sessionVariables.QT_QPA_PLATFORMTHEME = "qt5ct";
  environment.variables = {
    EDITOR = "vim";
    XMODIFIERS = "@im=fcitx";
    QT_IM_MODULES="wayland;fcitx";
    QT_IM_MODULE="fcitx";
    HYPRSHOT_DIR = "$HOME/Pictures/Screenshots";
    QT_QPA_PLATFORM = "wayland";
    _JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=lcd";
  };

  services.avahi = {
  enable = true;
  nssmdns4 = true;
  openFirewall = true;
};


  # envs to be preserved when using sudo
  security.sudo.extraConfig = ''
    Defaults env_keep += "http_proxy https_proxy"
  '';

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 6000 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
