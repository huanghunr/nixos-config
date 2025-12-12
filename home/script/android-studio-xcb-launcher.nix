{ pkgs ? import <nixpkgs> {}, ...}:
# fix avd gpu issue by forcing xcb platform
pkgs.stdenv.mkDerivation {
  pname = "android-studio-xcb-launcher";
  version = "1.0.0";

  src = ./.;

  nativeBuildInputs = [];

  buildInputs = [];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cp android-studio-xcb-launcher.sh $out/bin/android-studio-xcb-launcher
    chmod +x $out/bin/android-studio-xcb-launcher
  '';
}