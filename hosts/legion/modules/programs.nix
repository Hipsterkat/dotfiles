{ config, lib, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  programs = {
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };

    virt-manager.enable = true;
    adb.enable = true;
    firefox.enable = true;

    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };

    gamemode.enable = true;
    gamescope = {
      enable = true;
      capSysNice = true;
    };
  };
  
  environment.gnome.excludePackages = with pkgs; [
    orca
    evince
    geary
    gnome-backgrounds
    gnome-user-docs
    baobab
    epiphany
    gnome-characters
    gnome-clocks
    gnome-console
    gnome-contacts
    gnome-logs
    gnome-maps
    gnome-music
    gnome-system-monitor
    gnome-weather
    loupe
    gnome-connections
    simple-scan
    snapshot
    totem
    yelp
    gnome-software
  ];

  environment.systemPackages = with pkgs; [

    # Game
    lutris
    heroic
    retroarch
    protonup-qt
    prismlauncher
    mumble
    mangohud
    mangojuice

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
    qemu_kvm
    virt-manager
    quickemu
    virtio-win
    spice
    spice-gtk
    spice-protocol
    OVMF

    # Desktop
    gnome-tweaks
    nautilus
    gparted
    imagemagick
    gnome-shell-extensions
    cosmic-session
    papirus-icon-theme
    gnomeExtensions.blur-my-shell
    gnomeExtensions.just-perfection
    gnomeExtensions.arc-menu

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
    pciutils
    busybox
    toybox

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

    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav
    gst_all_1.gst-vaapi

    # Network
    putty
    networkmanagerapplet
    wireshark-qt
    scrcpy
    glogg

    # General
    lenovo-legion
    uget
    blender
    freecad-wayland
    qbittorrent
    obsidian
    bitwarden
    kicad
    openscad
    tor-browser

    # Deployment and shells
    waydroid
    distrobox
    alacritty
    
    (discord.override {
      withOpenASAR = true;
      withVencord = true;
    })
  ];
}
