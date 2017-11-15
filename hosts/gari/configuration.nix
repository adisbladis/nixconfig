# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  nvidiaDriver = "nvidia";

in {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../profiles/common.nix
      ../../profiles/graphical-desktop.nix
      ../../profiles/laptop.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_4_13;

  services.xserver.synaptics.enable = true;
  services.xserver.synaptics.additionalOptions = ''
    Option "LeftEdge"  "1"
    Option "RightEdge"  "2"
    Option "VertEdgeScroll"  "1"
    Option "AreaTopEdge"  "2500"
  '';

  #  Bumblebee has issues with tearing and crashes
  #  Power use is good enough without it anyway
  hardware.opengl.enable = true;
  hardware.opengl.extraPackages = [ pkgs.libvdpau-va-gl pkgs.vaapiVdpau pkgs.vaapiIntel];
  hardware.bumblebee.enable = true;
  hardware.bumblebee.connectDisplay = true;
  hardware.bumblebee.driver = nvidiaDriver;
  services.xserver.videoDrivers = ["modesetting"];

  # Touch screen in firefox
  environment.variables.MOZ_USE_XINPUT2 = "1";

  networking.hostName = "gari";
  boot.zfs.enableUnstable = true;
  networking.hostId = "a8c06607";
  networking.networkmanager.enable = true;

  fileSystems."/".options = ["noatime" "nodiratime"];
  fileSystems."/tmp" = {
    mountPoint = "/tmp";
    device = "tmpfs";
    fsType = "tmpfs";
    options = ["nosuid" "nodev" "relatime"];
  };

  hardware.cpu.intel.updateMicrocode = true;

  system.stateVersion = "18.03"; # Did you read the comment?

}
