{ config, lib, pkgs, ... }:

{
  boot.kernelParams = [
    "pcie_aspm=off"
    "nvidia-drm.modeset=1"
    "nvidia-drm.fbdev=1"
    "usbcore.autosuspend=-1"
  ];

  hardware.nvidia = {
    open = false;
    modesetting.enable = true;

    powerManagement.enable = false;
    powerManagement.finegrained = false;
    nvidiaPersistenced = true;

    package = config.boot.kernelPackages.nvidiaPackages.production;

    prime = {
      sync.enable = true;
      offload.enable = false;

      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;

    extraPackages = with pkgs; [
      intel-media-driver
      nvidia-vaapi-driver
      vaapiVdpau
      libvdpau-va-gl
    ];

    extraPackages32 = with pkgs.pkgsi686Linux; [
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  nixpkgs.config.nvidia.acceptLicense = true;

  environment.variables = {
    GBM_BACKEND = "nvidia-drm";
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", TEST=="power/control", ATTR{power/control}="on"
  '';

  boot.blacklistedKernelModules = [ "nouveau" ];

  hardware.nvidia-container-toolkit.enable = true;
}
