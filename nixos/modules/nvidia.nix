{
  config,
  ...
}:
{

  # Enable OpenGL
  hardware.graphics = {
    enable = true;
  };

  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;

  hardware.nvidia.prime = {
    #   offload = {
    #   enable = true;
    #   enableOffloadCmd = true;
    # };
    sync.enable = true;
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];
  services.xserver.deviceSection = ''
    Option "DRI" "2"
    Option "TearFree" "true"
  '';

  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.powerManagement.enable = false;
  hardware.nvidia.powerManagement.finegrained = false;
  hardware.nvidia.open = false;
  hardware.nvidia.nvidiaSettings = true;

  hardware.acpilight.enable = true;

  #If you encounter the problem of booting to text mode you might try adding the Nvidia kernel module manually with this
  #boot.initrd.kernelModules = [ "nvidia" ];
  #boot.extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];

  #disable nouveau
  boot.kernelParams = [
    "modprobe.blacklist=nouveau"
    # "acpi_backlight=video"
  ];

  #Screen Tearing Issues
  hardware.nvidia.forceFullCompositionPipeline = true;

}
