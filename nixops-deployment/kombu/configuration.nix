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


  users.users.root.initialHashedPassword = secrets.passwordHash;
  users.users.adisbladis.initialHashedPassword = secrets.passwordHash;
  users.mutableUsers = false;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostId = "b6d4529e";
  networking.hostName = "kombu";
  networking.networkmanager.enable = true;

  services.xserver.videoDrivers = [ "amdgpu" ];

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
