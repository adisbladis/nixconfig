{ config, lib, pkgs, ... }:

let
  cfg = config.my.gaming;

  nsz = pkgs.callPackage ./nsz { };

in
{
  options.my.gaming.enable = lib.mkEnableOption "Enables gaming related thingys.";

  config = lib.mkIf cfg.enable {
    networking.firewall = {

      allowedTCPPorts = [
        # Steam link
        27036
        27037

        # Moonlight game stream
        47984
        47989
        48010
      ];

      allowedUDPPorts = [
        # Steam link
        27031
        27036

        # Moonlight game stream
        5353
        47998
        47999
        48000
        48002
        48010
      ];
    };

    # I install steam through flatpak to avoid binary incompatibilities
    xdg.portal.enable = true;
    services.flatpak.enable = true;
    xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

    # Enable steam udev rules for ps4 controller support
    hardware.steam-hardware.enable = true;

    environment.systemPackages = [
      # Set PS4 LED colours
      pkgs.openrgb

      # Ps3
      pkgs.rpcs3

      # NES/SNES/N64/...
      pkgs.retroarchFull

      # Nintendo Switch
      pkgs.yuzu-mainline
      # nsz
    ];

  };
}
