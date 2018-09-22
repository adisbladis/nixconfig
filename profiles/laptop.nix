{ config, lib, pkgs, ... }:

with lib;

{
  environment.systemPackages = with pkgs; [
    acpi
  ];

  services.tlp.enable = true;
  powerManagement.cpuFreqGovernor =
    lib.mkIf config.services.tlp.enable (lib.mkForce null);

  services.udev.extraRules = ''
    # set deadline scheduler for non-rotating disks
    # according to https://wiki.debian.org/SSDOptimization, deadline is preferred over noop
    ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="deadline"
  '';

  services.fwupd.enable = true;

  hardware.trackpoint.enable = true;
  security.lockKernelModules = false;  # No wifi with this one enabled
}
