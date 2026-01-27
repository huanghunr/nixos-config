{pkgs,inputs,...}:
{
  home.packages = with pkgs; [
    (ghidra.withExtensions (p: with p; [
      ret-sync
      ghidra-extensions.wasm
      ghidra-extensions.kaiju
      ghidra-extensions.findcrypt
      ghidra-extensions.ghidra-firmware-utils
      ghidra-extensions.ghidra-golanganalyzerextension
    ]))
  ]
  ++
  [
    binwalk
  ]
  ++[
    inputs.pwndbg.packages.${pkgs.system}.default
  ]
  ++[
    pwntools
    ropgadget
  ];
}