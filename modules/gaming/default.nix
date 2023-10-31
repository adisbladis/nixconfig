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
    home-manager.users.adisbladis = { ... }: {
      # Run game streaming server
      systemd.user.services.sunshine = {
        Unit = {
          Description = "Start sunshine";
          After = [ "graphical-session-pre.target" ];
          PartOf = [ "graphical-session.target" ];
        };

        Install = { WantedBy = [ "graphical-session.target" ]; };

        Service = {
          ExecStart = lib.getExe' pkgs.sunshine "sunshine";
          Restart = "on-abort";
        };
      };
    };

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
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

      # # NES/SNES/N64/...
      # pkgs.retroarchFull

      # Game streaming
      pkgs.sunshine

      # Nintendo Switch
      pkgs.yuzu-mainline
      # nsz
    ];

  };
}
