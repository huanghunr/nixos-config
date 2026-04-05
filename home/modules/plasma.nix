{ pkgs, lib, config, ... }: {
  options.programs.plasma_home = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Plasma desktop environment";
    };
  };
}