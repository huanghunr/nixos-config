{ pkgs, upkgs, lib, config, ... }: {
  options.programs.plasma_home = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Plasma desktop environment";
    };
  };
  config = lib.mkIf config.programs.plasma_home.enable {
    home.packages = [
      upkgs.plasma-panel-colorizer
    ];
  };
}