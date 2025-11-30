{
  inputs,
  system,
  ...
}:
let
  inherit system;

  pkgs-extra-unstable = import inputs.nixpkgs-extra-unstable {
    inherit system;
    config.allowUnfree = true;
    config.android_sdk.accept_license = true;
  };

  pks-unstable = import inputs.nixpkgs-unstable {
    inherit system;
    config.allowUnfree = true;
    config.android_sdk.accept_license = true;
  };

  pkgs-stable = import inputs.nixpkgs-stable {
    inherit system;
    config.allowUnfree = true;
    config.android_sdk.accept_license = true;
  };

  pkgs-system = inputs.nixpkgs-unstable.lib.nixosSystem;
  # {
  #   modules = [
  #     {
  #       nixpkgs = {
  #         inherit system;
  #         config.allowUnfree = true;
  #         config.android_sdk.accept_license = true;
  #       };
  #     }
  #   ];
  # };

in
{
  inherit
    pkgs-extra-unstable
    pks-unstable
    pkgs-stable
    pkgs-system
    ;
}
