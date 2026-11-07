{
  description = "NixOS Raspberry Pi 4 SD card image";

  nixConfig = {
    extra-substituters = [
      "https://nixos-raspberrypi.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
    ];
  };

  inputs.nixos-raspberrypi.url = "github:nvmd/nixos-raspberrypi/main";

  outputs = { self, nixos-raspberrypi, ... }@inputs:
    let
      rpi4Modules = [
        nixos-raspberrypi.nixosModules.raspberry-pi-4.base
        ./configuration.nix
      ];
    in {
      # For an existing system: nixos-rebuild switch --flake .#rpi4
      nixosConfigurations.rpi4 = nixos-raspberrypi.lib.nixosSystemFull {
        specialArgs = inputs;
        modules = rpi4Modules ++ [
          {
            fileSystems."/" = {
              device = "/dev/disk/by-label/NIXOS_SD";
              fsType = "ext4";
            };
          }
        ];
      };

      # For a fresh SD card: nix build .#sdImage
      nixosConfigurations.rpi4-sd = nixos-raspberrypi.lib.nixosSystemFull {
        specialArgs = inputs;
        modules = rpi4Modules ++ [ nixos-raspberrypi.nixosModules.sd-image ];
      };

      packages.aarch64-linux.sdImage =
        self.nixosConfigurations.rpi4-sd.config.system.build.sdImage;
    };
}
