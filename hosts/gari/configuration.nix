# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

let
  secrets = import ../../secrets.nix;

in {

  imports = [
    ./hardware-configuration.nix
    ../../profiles/common.nix
    ../../profiles/graphical-desktop.nix
    ../../profiles/laptop.nix
  ];

  documentation.enable = false;

  environment.systemPackages = [
#    pkgs.sp-flash-tool
    pkgs.libva-utils
  ];

  programs.adb.enable = true;

  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_5_1;

  boot.initrd.availableKernelModules = [
    "aes_x86_64"
    "aesni_intel"
    "cryptd"
  ];

  # virtualisation.docker.enable = true;

  # nixpkgs.config.allowUnfree = true;
  # users.extraGroups.vboxusers.members = [ "adisbladis" ];
  # virtualisation.virtualbox.host.enable = true;
  # virtualisation.virtualbox.host.enableExtensionPack = true;

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

  services.acpid.enable = true;

  # Required by some clients
  # security.clamav.daemon.enable = true;

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
  hardware.opengl.extraPackages = [
    (pkgs.vaapiIntel.override { enableHybridCodec = true; })
    pkgs.vaapiVdpau
    pkgs.libva-utils
    pkgs.libvdpau-va-gl
    pkgs.intel-media-driver
  ];
  services.xserver.videoDrivers = [ "nouveau" "intel" ];
  services.xserver.deviceSection = ''
    Option        "Tearfree"      "true"
  '';
  boot.kernelParams = [ "i915.enable_psr=1" ];

  environment.variables = {
    MESA_LOADER_DRIVER_OVERRIDE = "iris";
  };
  hardware.opengl.package = (pkgs.mesa.override {
    galliumDrivers = [ "nouveau" "virgl" "swrast" "iris" ];
  }).drivers;

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

  services.udev.extraRules = ''
    ATTRS{idVendor}=="0e8d", ENV{ID_MM_DEVICE_IGNORE}="1"
    ATTRS{idVendor}=="6000", ENV{ID_MM_DEVICE_IGNORE}="1"
  '';

}
