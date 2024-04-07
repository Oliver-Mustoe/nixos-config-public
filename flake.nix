{
  description = "home flake";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-23.11";
    };
    unstable = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, unstable, ... }@inputs: {
    nixosConfigurations = {
      laptop01 = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = {
          unstable = import unstable {
            inherit system;
            config.allowUnfree = true;
          };
        };
        modules = [
          ./system-configurations/laptop01/laptop-configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.om = import ./system-configurations/laptop01/home.nix;
          }
        ];
      };
    };
  };
}
