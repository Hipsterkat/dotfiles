{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    # Other host modules are included from flake.nix to avoid duplicate imports here.
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_zen;
  };

  swapDevices = [
    {
      device = "/swapfile";
      size = 16 * 1024; # 32GB
    }
  ];

  nix = {
    optimise.automatic = true;
    settings.experimental-features = [ "nix-command" "flakes" ];
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 1d";
    };
  };

  networking = {
    hostName = "legion";
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [ 25565 ];
      allowedUDPPorts = [ 25565 ];
    };
  };

  users.users.hipst = {
    isNormalUser = true;
    description = "hipst";
    extraGroups = [
      "networkmanager"
      "wheel"
      "vboxusers"
      "adbusers"
      "docker"
      "libvirtd"
      "qemu-libvirtd"
      "kvm"
      "i2c"
    ];
  };

  time.timeZone = "Europe/Bucharest";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "ro_RO.UTF-8";
      LC_IDENTIFICATION = "ro_RO.UTF-8";
      LC_MEASUREMENT = "ro_RO.UTF-8";
      LC_MONETARY = "ro_RO.UTF-8";
      LC_NAME = "ro_RO.UTF-8";
      LC_NUMERIC = "ro_RO.UTF-8";
      LC_PAPER = "ro_RO.UTF-8";
      LC_TELEPHONE = "ro_RO.UTF-8";
      LC_TIME = "ro_RO.UTF-8";
    };
  };

  hardware = {
    enableRedistributableFirmware = true;
    i2c.enable = true;
    bluetooth.enable = true;
  };

  services = {
    openssh.enable = true;

    xserver = {
      enable = true;

      displayManager.gdm = {
        enable = true;
        wayland = true;
      };

      desktopManager.gnome.enable = true;

      xkb.layout = "us";
      xkb.variant = "";
    };

    libinput.enable = true;
    blueman.enable = true;
    power-profiles-daemon.enable = true;
    thermald.enable = true;

    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    fwupd.enable = true;
    flatpak.enable = true;

    printing = {
      enable = true;
      drivers = with pkgs; [
        hplipWithPlugin
        hplip
        cups-filters
        cups-browsed
      ];
    };

    hardware.openrgb = {
      enable = true;
      package = pkgs.openrgb;
      motherboard = "intel";
      server.port = 6742;
    };
  };

  programs = {
    xwayland.enable = true;
  };

  environment = {
    sessionVariables = {
      LIBVA_DRIVER_NAME = "iHD";
      __GL_VRR_ALLOWED = "1";
    };
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    noto-fonts-emoji
    fira-sans
    roboto
    noto-fonts-cjk-sans
    font-awesome
    material-icons
  ];

  xdg.portal = {
    enable = true;
    extraPortals = [ 
     pkgs.xdg-desktop-portal-gnome
     pkgs.xdg-desktop-portal-gtk
     ];
  };

  virtualisation = {
    # virtualbox.host.enable = true;
    # virtualbox.host.enableExtensionPack = true;

    # virtualbox.guest = {
    #   enable = true;
    #   dragAndDrop = true;
    # };

    waydroid.enable = true;
    docker.enable = true;

    libvirtd = {
      enable = true;
      onBoot = "start";
      onShutdown = "shutdown";
      qemu = {
        package = pkgs.qemu_kvm;
        swtpm.enable = true;
        ovmf.enable = true;
        ovmf.packages = [ pkgs.OVMF.fd ];
        runAsRoot = true;
      };
    };

    spiceUSBRedirection.enable = true;
  };

  security.rtkit.enable = true;

  system.stateVersion = "25.05";
}
