# Custom NixOS Raspberry Pi 4 image

This flake builds a bootable NixOS aarch64 SD-card image for a Raspberry Pi 4. It enables Ethernet DHCP and SSH, and creates a `pi` administrator account.

## Set your SSH key

Edit `configuration.nix` and replace:

```text
ssh-ed25519 PLACEHOLDER_REPLACE_THIS_KEY pi@example.invalid
```

with your real public key, for example the contents of `~/.ssh/id_ed25519.pub`.

The placeholder is intentionally not usable for login.

## Build

From this directory, on a system with Nix flakes enabled:

```sh
sudo nix build --accept-flake-config .#packages.aarch64-linux.sdImage
```

`--accept-flake-config` lets Nix use the project's binary cache, so the kernel doesn't have to be compiled locally. The result is linked at `result/sd-image/` and contains a compressed `.img.zst` file.

You can also build through the configuration attribute:

```sh
nix build --accept-flake-config .#nixosConfigurations.rpi4-sd.config.system.build.sdImage
```

To update an existing Pi running this configuration instead, use the `rpi4` configuration (this doesn't build an image):

```sh
sudo nixos-rebuild switch --accept-flake-config --flake .#rpi4
```

Building for `aarch64-linux` on an x86_64 machine may require a configured remote builder or binfmt emulation. The build can otherwise be run directly on an aarch64 NixOS host.

## Flash

After identifying the SD card device carefully with `lsblk`, decompress and write the image:

```sh
zstd -dc result/sd-image/*.img.zst | sudo dd of=/dev/sdX bs=4M status=progress conv=fsync
sudo sync
```

Replace `/dev/sdX` with the whole SD-card device, never a partition such as `/dev/sdX1`. Writing erases everything on that device, so unmount any of its partitions first if they were auto-mounted.

## First connection

Connect the Pi to Ethernet, find its DHCP address in your router, then connect using the key configured above:

```sh
ssh pi@<ip-address>
```

After logging in, make future configuration changes from the checked-out flake or copy it onto the Pi and run:

```sh
sudo nixos-rebuild switch --accept-flake-config --flake /path/to/nixos-rpi4-flake#rpi4
```
