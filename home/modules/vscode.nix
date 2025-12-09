{ pkgs, ... }:
let
  inherit (pkgs) vscode-utils;
  # nix-env-selector = vscode-utils.extensionFromVscodeMarketplace {
  #   name = "nix-env-selector";
  #   publisher = "arrterian";
  #   version = "1.1.0";
  #   sha256 = "sha256:0mralimyzhyp4x9q98x3ck64ifbjqdp8cxcami7clvdvkmf8hxhf";
  # };
  # vscode-css-peek = vscode-utils.extensionFromVscodeMarketplace {
  #   name = "css-peek";
  #   publisher =  "Pranay Prakash";
  #   version = "4.4.0";
  #   sha256 = "sha256:0mralimyzhyp4x9q98x3ck64ifbjqdp8cxcami7clvdvkmf8hxhf";
  # };
in
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhs;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      # yzhang.markdown-all-in-one
      # ms-python.vscode-pylance
      # ms-python.python
      # ms-python.debugpy
      # ms-python.black-formatter
      # jnoortheen.nix-ide
      # ecmel.vscode-html-css
      # nix-env-selector
      # github.copilot
      # github.copilot-chat
      # vscode-css-peek
    ];
  };
}
