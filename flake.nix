{
  description = "Raspberry Pi 4 with camera support";

nixConfig = {
    extra-substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://nixos-raspberrypi.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
    ];
  };

  inputs = {
    nixpkgs.follows = "nixos-raspberrypi/nixpkgs";
    nixos-raspberrypi.url = "github:nvmd/nixos-raspberrypi?shallow=1";
  };

  outputs = { self, nixpkgs, nixos-raspberrypi, disko }: 
  {
    nixosConfigurations.artemis = nixos-raspberrypi.lib.nixosSystemFull {
      system = "aarch64-linux";
      specialArgs = { inherit nixos-raspberrypi nixpkgs; };
      modules = [
        disko.nixosModules.disko        
        ./configuration.nix
        ({ config, pkgs, lib, nixos-raspberrypi, ... }: {
          imports = with nixos-raspberrypi.nixosModules; [
            # Hardware configuration
            raspberry-pi-4.base
            raspberry-pi-4.display-vc4
            raspberry-pi-4.bluetooth
          ];
        })
      ];
    };
  };
}

