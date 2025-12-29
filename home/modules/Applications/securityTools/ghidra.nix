{pkgs,...}:
{
  home.package = with pkgs; [
    ghidra.withExtensions (p: with p; [
      ret-sync
      ghidra-extensions.wasm
      ghidra-extensions.kaiju
      ghidra-extensions.findcrypt
      ghidra-extensions.ghidra-firmware-utils
      ghidra-extensions.ghidra-golanganalyzerextension
    ])
  ];
}