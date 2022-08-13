{ config, lib, pkgs, ... }:

let
  cfg = config.my.gaming;

  nsz = pkgs.callPackage ./nsz { };

in
{
  options.my.gaming.enable = lib.mkEnableOption "Enables gaming related thingys.";

  config = lib.mkIf cfg.enable {
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
      pkgs.yuzu-ea
      nsz
    ];

  };
}
