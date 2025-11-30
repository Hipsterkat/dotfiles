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
    
  ];
}
