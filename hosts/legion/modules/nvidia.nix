{ config, lib, pkgs, ... }:

{
  boot.blacklistedKernelModules = [ "nouveau" ];
  boot.kernelModules = [ 
    "nvidia" 
    "nvidia_modeset" 
    "nvidia_uvm" 
    "nvidia_drm"
    ];
    
    boot.kernelParams = [
    "pcie_aspm=off"
    "nvidia-drm.modeset=1"
    ];
  
  hardware.nvidia = {
    open = lib.mkDefault false;
    modesetting.enable = true;
    powerManagement = {
      enable = lib.mkForce false;
      finegrained = lib.mkForce false;
    };
    package = config.boot.kernelPackages.nvidiaPackages.production;
    nvidiaSettings = true;
    nvidiaPersistenced = true;
    prime = {
      sync.enable = true;
      offload = {
        enable = lib.mkForce false;
        enableOffloadCmd = lib.mkForce false;
      };
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

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

  services.xserver.videoDrivers = [ "nvidia" ];
  
  hardware.nvidia-container-toolkit.enable = true;
}
