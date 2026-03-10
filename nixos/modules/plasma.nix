{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.programs.plasma_option = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Plasma desktop environment";
    };
  };

  config = lib.mkIf config.programs.plasma_option.enable {
    services.desktopManager.plasma6.enable = true; # if use Plasma desktop
  };
}
