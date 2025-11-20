let
  shellAliases = {
    "zj" = "zellij";
  };
in
{
  programs.zellij = {
    enable = true;
  };
  # only works in bash/zsh, not nushell
  home.shellAliases = shellAliases;
  programs.nushell.shellAliases = shellAliases;

  overlays = with inputs; [
    (final: prev: {
      zjstatus = inputs.zjstatus.packages.${prev.system}.default;
    })
  ];
}