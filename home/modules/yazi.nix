{
  pkgs,
  config,
  inputs,
  ...
}:
{
  home.packages = [
    (inputs.yazi.packages.${pkgs.system}.default.override {
      _7zz = pkgs._7zz-rar; # Support for RAR extraction
    })
  ];
  programs.yazi = {
    enable = true;
    plugins = {
      inherit (pkgs.yaziPlugins) wl-clipboard mount git zoom recycle-bin compress chmod bunny;
    };
  };
}
