build-image:
  nix build .#sd-image

deploy:
  nixos-rebuild switch --flake .#artemis --build-host localhost --target-host root@192.168.10.203

rebuild:
  nixos-rebuild switch --flake .#artemis
