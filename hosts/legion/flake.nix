{
  description = "desc here";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      ...
    }@inputs:
    {

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
              ./system/configuration.nix # Main configuration

              inputs.home-manager.nixosModules.home-manager
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
