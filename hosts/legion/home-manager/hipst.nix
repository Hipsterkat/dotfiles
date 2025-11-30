{ inputs, pkgs, config, ... }:

{
  home.username = "hipst";
  home.homeDirectory = "/home/hipst";

  home.stateVersion = "25.05";
  home.enableNixpkgsReleaseCheck = false;

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName = "Hipsterkat";
    userEmail = "hipsterkatze@hotmail.com";
  };

  programs.neovim = {
  enable = true;

  extraPackages = with pkgs; [
    ripgrep
    fd
    gcc
  ];
};

  # Example: user packages
  home.packages = with pkgs; [
    protonplus
    protontricks

  ];

  programs = {
    nix-your-shell = {
      enable = true;
      enableFishIntegration = true;
    };

    obs-studio = {
      enable = true;
      plugins = with pkgs; [
        obs-studio-plugins.obs-vkcapture
        obs-studio-plugins.obs-pipewire-audio-capture
        obs-studio-plugins.obs-text-pthread
      ];
    };

    direnv = {
      enable = true;
      silent = true;
      nix-direnv.enable = true;
    };
  };

home.stateVersion = "24.11";
home.enableNixpkgsReleaseCheck = false;
}
