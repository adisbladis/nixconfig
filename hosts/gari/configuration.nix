{ config, pkgs, ... }:

let
  nvidiaDriver = "nouveau";

in {
  imports = [
    ./hardware-configuration.nix
    ../../profiles/common.nix
    ../../profiles/graphical-desktop.nix
    ../../profiles/laptop.nix
  ];

  boot.initrd.availableKernelModules = [
    "aes_x86_64"
    "aesni_intel"
    "cryptd"
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

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

  networking.hostId = "a8c06607";

  fileSystems."/".options = [ "noatime" "nodiratime" ];
  fileSystems."/tmp" = {
    mountPoint = "/tmp";
    device = "tmpfs";
    fsType = "tmpfs";
    options = [ "nosuid" "nodev" "relatime" ];
  };

  hardware.cpu.intel.updateMicrocode = true;

  system.stateVersion = "18.09"; # Did you read the comment?

}
