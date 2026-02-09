{
  config,
  lib,
  pkgs,
  ...
}:

let
  mainPath = "${config.home.homeDirectory}/Applications/ida92";
  binaryPath = "${mainPath}/ida";
  iconPath = "${mainPath}/appico.png";
  fhsEnvName = "ida-fhs-env";

  name = "IDA Pro";
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

  idaPythonEnv = pkgs.python3.withPackages (ps: with ps; [
    yara-python
    debugpy
    tornado
    keystone-engine 
    setuptools
    z3-solver
    capstone
    ropper
    unicorn
    requests
    pwntools
    pycryptodome
  ]);

  idaFhsEnv = pkgs.buildFHSEnv {
    name = fhsEnvName;

    targetPkgs =
      pkgs:
      (with pkgs; [
        idaPythonEnv

        zlib
        glib
        libxml2
        dbus
        fontconfig
        freetype

        xorg.libX11
        xorg.libxcb
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
      export PYTHONHOME="${idaPythonEnv}"
      export PYTHONPATH="${idaPythonEnv}/${idaPythonEnv.sitePackages}"
      export LD_LIBRARY_PATH="${idaPythonEnv}/lib:$LD_LIBRARY_PATH"
    '';

    # runScript = "bash";
    runScript = "${toString binaryPath}";
  };

in
{
  options.programs.local-ida = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = hasBinary;
      description = "Enable local installation of IDA Pro.";
    };
  };

  config = lib.mkIf config.programs.local-ida.enable {
    home.packages = [ idaFhsEnv ];
    xdg.desktopEntries.ida = {
      exec = "${idaFhsEnv}/bin/${fhsEnvName}";
      terminal = false;
      inherit name genericName icon categories mimeType;
    };
  };
}
