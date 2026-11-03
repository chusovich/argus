# Argus
Nix fake for a Raspberry Pi based IP-camera

## Goals
- Hardware: the project will be testing on a Raspberry Pi 4 with 1GB of RAM and the offical Rasbperry Pi camera module, but the setup should work for different Pi's and cameras
- The video stream should be optimized for [Frigate](https://frigate.video/)
- The flake should be "batteries include" but also allow from customization (hostname, IP address, etc.)

## Example Flake
```nix
# working on it..
```

## Updating
It is recommended to build on your local machine and deploy the flake to your Pi.
```nix
sudo nixos-rebuild switch --flakle .#hostame --target-host root@<ip-address/hostname>
```

> [!NOTE]
> You may have to enable arm emulation to build the flake on your local machine
```nix
# Enable arm/raspi builds
boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
nix.settings.extra-platforms = [ "aarch64-linux" ];
```

## Installing for the First Time
### 1) Build the SD Card Image
```sh
just build-image
```
- The image is a fully configured system built from this flake
- Output is in `result/sd-image/`

### 2) Decompress
`result` is read-only, so decompress the image somewhere else:

```sh
zstd -d result/sd-image/*.img.zst -o ~/artemis.img
```

### 3) Flash the SD Card
Write `~/artemis.img` to the SD card with Raspberry Pi Imager, Etcher, or `dd`.

### 4) Boot the Pi
- Insert the SD card and power on
- Wait for the first boot to finish

### 5) Confirm SSH Access
```sh
ssh root@<ip-address>
```

## References
- [nixos-raspberrypi Flake GitHub](https://github.com/nvmd/nixos-raspberrypi)
- [Raspberry Pi device tree overlay options](https://github.com/raspberrypi/linux/blob/rpi-6.6.y/arch/arm/boot/dts/overlays/README)
- [nixos discourse: how to best deploy to raspberry pi](https://discourse.nixos.org/t/how-best-to-deploy-to-raspberry-pi/70410/8)
