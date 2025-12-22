{ pkgs,  ... }:
{
  programs.gamemode.enable = true;
  programs.gamescope.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    package = pkgs.steam.override {
      extraPkgs =
        pkgs': with pkgs'; [
          xorg.libXcursor
          xorg.libXi
          xorg.libXinerama
          xorg.libXScrnSaver
          libpng
          libpulseaudio
          libvorbis
          stdenv.cc.cc.lib
          libkrb5
          keyutils
        ];
    };
  };
  environment.systemPackages =
    with pkgs;
    (
      # AppImage support
      [
        electron
        (appimage-run.override {
          extraPkgs =
            pkgs: with pkgs; [
              nss
              nspr
              xorg.libxshmfence
              xorg.libX11
              xorg.libXcomposite
              xorg.libXdamage
              xorg.libXext
              xorg.libXfixes
              xorg.libXrandr
              xorg.libxcb
              xorg.libxkbfile
              alsa-lib
              mesa
              gtk3
              gdk-pixbuf
              cairo
              pango
              at-spi2-atk
              cups
              libdrm
              libxkbcommon
            ];
        })
      ]
      ++
      # game support
      [
        (heroic.override {
          extraPkgs = pkgs: [
            pkgs.gamemode
            pkgs.gamescope
          ];
        })
      ]
    );
}
