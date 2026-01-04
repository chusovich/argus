{ config, pkgs, lib, ... }:

{
  hardware.raspberry-pi.config.all = {
    options = { };
    dt-overlays = { 
      cma = {
        enable = true;
        params = { 
          cma-128 = {
            enable = true; 
          };
        };
      };
    };
  };
}
