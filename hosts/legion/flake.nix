{
  description = "desc here";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    l5p-keyboard-rgb = {
      url = "github:4JX/L5P-Keyboard-RGB/4f2d1e74f5f7e90da82dab1d01d95a4e517c6b32";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }: {

    nixosConfigurations = {
      legion =
        let
          system = "x86_64-linux";
        in
        # Set the default pkgs the system follows
        inputs.nixpkgs.lib.nixosSystem {
          inherit system;

          # This makes these args available in all other modules
          specialArgs = {
            inherit inputs;
          };

          modules = [
            ./system/configuration.nix
            ./modules/nvidia.nix
            ./modules/programs.nix
            ./modules/lenovo.nix
            ./modules/vfio.nix
            ./modules/niri.nix

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                inherit inputs;
              };
              home-manager.users = {
                hipst = import ./home-manager/hipst.nix;
              };
            }
          ];
        };
    };
  };
}
