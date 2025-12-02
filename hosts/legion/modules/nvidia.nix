{ config, lib, pkgs, ... }:

{
hardware.nvidia-container-toolkit.enable = true;

boot.blacklistedKernelModules = [ "nouveau" ];
services.xserver.videoDrivers = [ "nvidia" "modesetting" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [ 
      vaapiVdpau 
      libvdpau-va-gl
      intel-media-driver
      # intel-vaapi-driver
      nvidia-vaapi-driver 
    ];
  };

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    nvidiaPersistenced = true;

    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.latest;
    prime = {
      # Drive all displays (including external) via NVIDIA to avoid sluggish hybrid/offload behaviour.
      sync.enable = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
}