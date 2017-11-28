{ config, lib, pkgs, ... }:

with lib;

{
  environment.systemPackages = with pkgs; [
    acpi
  ];

  services.tlp.enable = true;

  services.udev.extraRules = ''
    # set deadline scheduler for non-rotating disks
    # according to https://wiki.debian.org/SSDOptimization, deadline is preferred over noop
    ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="deadline"
  '';

  hardware.trackpoint.enable = true;
  services.xserver.synaptics.enable = true;
  security.lockKernelModules = false;  # No wifi with this one enabled
}
