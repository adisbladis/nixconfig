{ config, lib, pkgs, ... }:

let
  cfg = config.my.podman;

in
{

  options.my.podman.enable = lib.mkEnableOption "Enables global settings required by podman.";

  config = lib.mkIf cfg.enable {
    virtualisation.podman.enable = true;
    virtualisation.podman.dockerCompat = true;

    networking.firewall.interfaces.podman0.allowedUDPPorts = [ 53 ];

    environment.systemPackages = [
      pkgs.podman-compose
    ];

  };

}
