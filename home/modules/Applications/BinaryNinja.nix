{
  config,
  lib,
  ...
}:

let
  pkgs = import (fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/5ae3b07d8d6527c42f17c876e404993199144b6a.tar.gz";
    sha256 = "sha256-6eeL1YPcY1MV3DDStIDIdy/zZCDKgHdkCmsrLJFiZf0=";
  }) { system = "x86_64-linux"; };
  mainPath = "${config.home.homeDirectory}/Applications/binaryninja";
  binaryPath = "${mainPath}/binaryninja";
  iconPath = "${mainPath}/api-docs/cpp/logo.png";
  fhsEnvName = "binaryninja-fhs-env";

  name = "Binary Ninja";
  genericName = "Disassembler";
  icon = iconPath;
  categories = [
    "Development"
    "Debugger"
  ];
  mimeType = [
    "application/x-executable"
    "application/octet-stream"
  ];

  # check whether the file exists
  hasBinary = builtins.pathExists binaryPath;

  pythonEnv = pkgs.python3.withPackages (
    ps: with ps; [
      # yara-python
      # debugpy
      # tornado
      # keystone-engine
      # setuptools
      # z3-solver
      # capstone
      # ropper
      # unicorn
      # requests
      # pwntools
      # pycryptodome
    ]
  );

   binaryninjaFhsEnv = pkgs.buildFHSEnv {
    name = fhsEnvName;

    targetPkgs =
      pkgs:
      (with pkgs; [
        pythonEnv

        zlib
        glib
        libxml2
        dbus
        fontconfig
        freetype

        xorg.libX11
        libxcb
        xorg.xcbutil
        xorg.xcbutilimage
        xorg.xcbutilkeysyms
        xorg.xcbutilrenderutil
        xorg.xcbutilwm
        libxkbcommon
        libglvnd

        wayland
        wayland-protocols

        qt6.qtbase
        qt6.qtwayland
      ]);

    profile = ''
      export PYTHONHOME="${pythonEnv}"
      export PYTHONPATH="${pythonEnv}/${pythonEnv.sitePackages}"
      export LD_LIBRARY_PATH="${pythonEnv}/lib:$LD_LIBRARY_PATH"
    '';

    # runScript = "bash";
    runScript = "${toString binaryPath}";
  };

in
{
  options.programs.local-bn = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = hasBinary;
      description = "Enable local installation of Binary Ninja.";
    };
  };

  config = lib.mkIf config.programs.local-bn.enable {
    home.packages = [ binaryninjaFhsEnv ];
    xdg.desktopEntries.binaryninja = {
      exec = "${binaryninjaFhsEnv}/bin/${fhsEnvName}";
      terminal = false;
      inherit
        name
        genericName
        icon
        categories
        mimeType
        ;
    };
  };
}
