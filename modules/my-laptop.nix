{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.my.laptop;

in {
  options.my.laptop.enable = mkEnableOption "Enables laptop related thingies.";

  config = mkIf cfg.enable {

    hardware.bluetooth.enable = true;

    environment.systemPackages = with pkgs; [
      acpi
    ];

    services.acpid.enable = true;

    services.tlp.enable = true;
    powerManagement.cpuFreqGovernor = lib.mkForce null;

    services.fwupd.enable = true;

    security.lockKernelModules = false;  # No wifi with this one enabled

    hardware.pulseaudio.extraModules = [ pkgs.pulseaudio-modules-bt ];

  };
}
