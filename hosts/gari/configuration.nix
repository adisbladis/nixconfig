# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  secrets = import ../../secrets.nix;

in {

  imports = [
    ./hardware-configuration.nix
    ../../profiles/common.nix
    ../../profiles/graphical-desktop.nix
    ../../profiles/laptop.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.initrd.availableKernelModules = [
    "aes_x86_64"
    "aesni_intel"
    "cryptd"
  ];

  environment.etc."nixos".source = pkgs.runCommand "persistent-link" {} ''
    ln -s /nix/persistent/etc/nixos $out
  '';

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  users.users.root.initialHashedPassword = secrets.passwordHash;
  users.users.adisbladis.initialHashedPassword = secrets.passwordHash;
  users.mutableUsers = false;

  system.stateVersion = "18.09"; # Did you read the comment?

  virtualisation.docker.enable = true;

  services.acpid.enable = true;

  hardware.bluetooth.enable = true;

  services.xserver.synaptics.enable = true;
  # Make trackpad act as scroll wheel
  services.xserver.synaptics.additionalOptions = ''
    Option "LeftEdge"  "1"
    Option "RightEdge"  "2"
    Option "VertEdgeScroll"  "1"
    Option "AreaTopEdge"  "2500"
  '';

  #  Bumblebee has issues with tearing and crashes
  #  Power use is good enough without it anyway
  hardware.opengl.enable = true;
  hardware.opengl.extraPackages = with pkgs; [ vaapiIntel ];
  services.xserver.videoDrivers = [ "modesetting" ];
  boot.kernelParams = [ "i915.enable_psr=1" ];

  # Touch screen in firefox
  environment.variables.MOZ_USE_XINPUT2 = "1";

  networking.hostName = "gari";

  fileSystems."/".options = [ "noatime" "nodiratime" ];
  fileSystems."/tmp" = {
    mountPoint = "/tmp";
    device = "tmpfs";
    fsType = "tmpfs";
    options = [ "nosuid" "nodev" "relatime" ];
  };

  hardware.cpu.intel.updateMicrocode = true;

}
