{ config, lib, pkgs, ... }:
let
  cfg = config.my.laptop;

in
{
  options.my.laptop.enable = lib.mkEnableOption "Enables laptop related thingies.";

  config = lib.mkIf cfg.enable {

    # A laptop is a desktop PC
    my.desktop.enable = true;

    environment.systemPackages = [
      pkgs.acpi
    ];

    services.acpid.enable = true;

    hardware.enableRedistributableFirmware = true;

    services.power-profiles-daemon.enable = true;

    powerManagement.cpuFreqGovernor = lib.mkForce null;

    programs.light.enable = true;

    security.lockKernelModules = false; # No wifi with this one enabled

    home-manager.users.adisbladis = { ... }: {

      systemd.user.services.my-battery-monitor = {
        Unit = {
          Description = "My battery notifier";
          After = [ "graphical-session-pre.target" ];
          PartOf = [ "graphical-session.target" ];
        };

        Install = { WantedBy = [ "graphical-session.target" ]; };

        Service = {
          ExecStart = "${pkgs.callPackage ../pkgs/battery-monitor { }}/bin/battery-monitor";
          Restart = "on-abort";
        };
      };

    };

  };
}
