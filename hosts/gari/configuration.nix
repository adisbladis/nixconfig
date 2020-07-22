# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

{

  imports = [
    ./hardware-configuration.nix

    ../../modules
  ];

  security.doas.enable = true;

  # security.pam.u2f.enable = true;
  security.pam.services.sudo.u2fAuth = true;
  security.pam.services.doas.u2fAuth = true;

  security.pam.u2f.authFile = pkgs.writeText "u2f_keys" ''
    adisbladis:4tTUtBtgsj9ANcqfkjiK1Lh0dcacIkH_8013_D4rd7kNIg383jhnVS28aqxhxj0b7reCK_zPwCmGOkDRDUb8jg,04db86d74a17ea3031765fc23ecfa9a860a72929887dfc92e965574c38d4d2f23c56ea0c4f31f33edccce9713a37001fdde0d7c8b13d59118f4ebc4d28c4e06a15
  '';

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  my.common-cli.enable = true;
  my.common-graphical.enable = true;
  my.laptop.enable = true;
  my.podman.enable = true;

  boot.initrd.availableKernelModules = [
    "aes_x86_64"
    "aesni_intel"
    "cryptd"
  ];

  networking.hostId = "f118a855";

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.trackpoint.enable = true;

  services.xserver.synaptics.enable = true;
  # Make trackpad act as scroll wheel
  services.xserver.synaptics.additionalOptions = ''
    Option "LeftEdge"  "1"
    Option "RightEdge"  "2"
    Option "VertEdgeScroll"  "1"
    Option "AreaTopEdge"  "2500"
  '';

  hardware.opengl.extraPackages = [
    (pkgs.vaapiIntel.override { enableHybridCodec = true; })
    pkgs.vaapiVdpau
    pkgs.libva-utils
    pkgs.libvdpau-va-gl
    pkgs.intel-media-driver
  ];
  services.xserver.videoDrivers = lib.mkForce [
    # "nouveau"
    "intel"
  ];
  services.xserver.deviceSection = ''
    Option        "Tearfree"      "true"
  '';
  boot.kernelParams = [ "i915.enable_psr=1" ];
  # environment.variables = {
  #   MESA_LOADER_DRIVER_OVERRIDE = "iris";
  # };

  networking.hostName = "gari";

  fileSystems."/".options = [ "noatime" "nodiratime" ];
  fileSystems."/tmp" = {
    mountPoint = "/tmp";
    device = "tmpfs";
    fsType = "tmpfs";
    options = [ "nosuid" "nodev" "relatime" ];
  };

  hardware.cpu.intel.updateMicrocode = true;

  # Gemini PDA
  services.udev.extraRules = ''
    ATTRS{idVendor}=="0e8d", ENV{ID_MM_DEVICE_IGNORE}="1"
    ATTRS{idVendor}=="6000", ENV{ID_MM_DEVICE_IGNORE}="1"
  '';

  system.stateVersion = "20.09"; # Did you read the comment?

}
