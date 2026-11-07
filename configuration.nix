{ pkgs, ... }:

{
  boot.loader.raspberry-pi.bootloader = "kernel";

  networking.hostName = "nixos-rpi4";
  networking.useDHCP = true;
  networking.firewall.allowedTCPPorts = [ 22 ];

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 2 * 1024;
    }
  ];

  time.timeZone = "UTC";

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
  };

  users.users.pi = {
    isNormalUser = true;
    description = "Raspberry Pi administrator";
    extraGroups = [ "wheel" ];
    initialPassword = "pipassword";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPGio/sga7gD8ivT3zGDHzp89ex9Hy6I1ofNbhtpRQoh calebmhusovich@gmail.com"
    ];
  };

  security.sudo.wheelNeedsPassword = false;

  # Useful tools on the first boot.
  environment.systemPackages = with pkgs; [
    git
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Required for every NixOS configuration.
  system.stateVersion = "25.11";
}
