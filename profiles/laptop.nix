{ config, lib, pkgs, ... }:

with lib;

{
  environment.systemPackages = with pkgs; [
    acpi
  ];

  services.tlp.enable = true;
  services.tlp.extraConfig = ''
    DISK_DEVICES="sda"
    DISK_IOSCHED="noop"
  '';

  hardware.trackpoint.enable = true;
  services.xserver.synaptics.enable = true;
  security.lockKernelModules = false;  # No wifi with this one enabled
}
