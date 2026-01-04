{ config, pkgs, lib, ... }:

{
  hardware = {
    raspberry-pi.config.all = {
      dt-overlays = {
        cma = {
          enable = true;
          params = {
            cma-size = {
              enable = true; 
              value = "128000000";
            };
          };
        };
      };
    };
  };
}
