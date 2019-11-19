{ config, pkgs, ... }:

let
  secrets = import ../../secrets.nix;

in {
  imports = [
    ./hardware-configuration.nix
    ../../profiles/common.nix
    ../../profiles/graphical-desktop.nix
  ];

  # For tmpfs /
  environment.etc."nixos".source = pkgs.runCommand "persistent-link" {} ''
    ln -s /nix/persistent/etc/nixos $out
  '';

  # For steam
  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.support32Bit = true;

  hardware.openrazer.enable = true;
  users.users.adisbladis.extraGroups = [ "plugdev" ];

  virtualisation.docker.enable = true;

  environment.systemPackages = [
    pkgs.steam
    pkgs.hedgewars
  ];

  boot.initrd.availableKernelModules = [
    "aes_x86_64"
    "aesni_intel"
    "cryptd"
  ];

  users.users.root.initialHashedPassword = secrets.passwordHash;
  users.users.adisbladis.initialHashedPassword = secrets.passwordHash;
  users.mutableUsers = false;

  services.xserver.deviceSection = ''
    Option        "Tearfree"      "true"
  '';

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostId = "b6d4529e";
  networking.hostName = "kombu";
  networking.networkmanager.enable = true;

  services.xserver.videoDrivers = [
    "amdgpu"
    "dummy"  # For xpra
  ];

  hardware.cpu.amd.updateMicrocode = true;

  hardware.enableRedistributableFirmware = true;

  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.passwordAuthentication = false;

  networking.useDHCP = false;
  networking.interfaces.eno1.useDHCP = true;
  networking.interfaces.eno2.useDHCP = true;
  networking.interfaces.wlp37s0.useDHCP = true;

  system.stateVersion = "20.03"; # Did you read the comment?


}
