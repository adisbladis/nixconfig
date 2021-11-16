{ config, lib, pkgs, ... }:
let
  cfg = config.my.laptop;

in
{
  options.my.laptop.enable = lib.mkEnableOption "Enables laptop related thingies.";

  config = lib.mkIf cfg.enable {

    # A laptop is a desktop PC
    my.desktop.enable = true;

    hardware.bluetooth.enable = true;

    environment.systemPackages = [
      pkgs.acpi
    ];

    services.acpid.enable = true;

    hardware.enableRedistributableFirmware = true;

    services.tlp.enable = true;

    powerManagement.cpuFreqGovernor = lib.mkForce null;

    services.fwupd.enable = true;

    programs.light.enable = true;

    security.lockKernelModules = false; # No wifi with this one enabled
  };
}
