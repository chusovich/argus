switch:
  sudo nixos-rebuild switch --flake .#artemis

deploy:
  sudo nixos-rebuild switch --flake .#artemis --target-host artemis --use-remote-sudo
  
debug:
  sudo nixos-rebuild switch --flake .#artemis --target-host artemis --use-remote-sudo --verbose --show-trace

install:
  nix run nixpkgs#nixos-anywhere --flake .#artemis generate-hardware-config nixos-generate-config /hardware-configuration.nix root@artemis
