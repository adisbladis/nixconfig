{ config, lib, pkgs, ... }:

with lib;

{
  environment.systemPackages = with pkgs; [
    acpi
  ];

  services.tlp.enable = true;
  powerManagement.cpuFreqGovernor =
    lib.mkIf config.services.tlp.enable (lib.mkForce null);

  services.fwupd.enable = true;

  hardware.trackpoint.enable = true;
  security.lockKernelModules = false;  # No wifi with this one enabled
}
