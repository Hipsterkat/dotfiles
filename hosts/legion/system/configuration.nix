{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_lqx;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  nix.optimise.automatic = true;

	swapDevices = [
	  {
	    device = "/swapfile";
	    size = 16 * 1024; # 32GB
	  }
	];


  networking.hostName = "legion";
  networking.networkmanager.enable = true;

  services.openssh.enable = true;

    networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 6742 25565 ];
    allowedUDPPorts = [ 25565 ];
  };


  time.timeZone = "Europe/Bucharest";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
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

  services.xserver = {
    enable = true;

    displayManager.gdm = {
      enable = true;
      wayland = true;
    };

    desktopManager.gnome.enable = true;
    videoDrivers = [ "nvidia" ];

    xkb.layout = "us";
    xkb.variant = "";
  };

  programs.xwayland.enable = true;

  hardware.graphics.enable = true;

  hardware.nvidia = {
    open = true;
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = true;
    nvidiaPersistenced = true;
  };

  hardware.nvidia.prime = {
    offload.enable = true;
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  fonts.packages = with pkgs; [
    noto-fonts-emoji
    fira-sans
    roboto
    noto-fonts-cjk-sans
    font-awesome
    material-icons
  ];

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
  };

  services.pulseaudio.enable = false;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  security.rtkit.enable = true;

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  services.printing.enable = true;

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
    ];
  };

  virtualisation = {

  #  virtualbox.host = {
  #    enable = true;
  #    enableExtensionPack = true;
  #  };

  #  virtualbox.guest = {
  #    enable = true;
  #    dragAndDrop = true;
  #  };

    docker.enable = true;

    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
        ovmf.enable = true;
        runAsRoot = true;
      };
    };

    spiceUSBRedirection.enable = true;
  };

services.hardware.openrgb = { 
  enable = true; 
  package = pkgs.openrgb-with-all-plugins; 
  motherboard = "amd"; 
  server = { 
    port = 6742; 
  }; 

};

  programs.adb.enable = true;

  programs.neovim = {
  enable = true;
  defaultEditor = true;
  viAlias = true;
  vimAlias = true;
};

  programs.firefox.enable = true;
  services.flatpak.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  programs.gamemode.enable = true;

  nixpkgs.config.allowUnfree = true;

  #hyprland = {
	    #enable = true;
	    #xwayland.enable = true;
	    #withUWSM = true;
	    #systemd.enable = true;
	    #portalPackage = xdg-desktop-portal-hyprland;
	    #package = unstable.hyprland;
	  #};


  environment.systemPackages = with pkgs; [

    # Game
    lutris
    heroic
    retroarch
    protonup-qt
    prismlauncher
    openrgb
    mumble

    # Code
    vscode
    neovim

    # Programming languages and tools
    python3
    python3Packages.pip
    maven
    mongodb-compass
    gcc
    clang
    rustup
    openssl

    # Nixos
    nh
    home-manager
    nixfmt-rfc-style

    # Virtualization
    virtualbox
    docker-compose
    wine-staging
    winetricks
    libvirt
    qemu
    virt-manager
    spice
    spice-gtk
    spice-protocol
    OVMF
    bash


    # Desktop
    gnome-tweaks
    nautilus
    gparted
    imagemagick

    # Utilities
    git
    gh
    lazygit
    lazydocker
    bruno
    postman
    bruno-cli
    gnumake
    coreutils
    meson
    ninja
    man-pages-posix
    bat
    wget
    curl
    starship
    thefuck
    fastfetch
    appimage-run

    # File Management
    yazi
    p7zip
    unzip
    zip
    unrar
    file-roller
    ncdu
    duf
    ntfs3g
    os-prober

    # Media
    signal-desktop
    telegram-desktop
    spotify
    discord
    stremio
    ffmpeg
    mpv
    yt-dlp
    youtube-music

    # Network
    putty
    networkmanagerapplet

    # General
    uget
    blender
    freecad-wayland
    qbittorrent
    obsidian
    bitwarden
    kicad
    openscad
    tor-browser
  ];

  system.stateVersion = "25.05";
}
