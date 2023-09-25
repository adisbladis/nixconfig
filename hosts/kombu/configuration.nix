{ config, pkgs, lib, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../modules
    ];

  my.ephemeral-root.enable = true;
  my.desktop.enable = true;
  my.gaming.enable = true;

  services.xserver.dpi = 140;

  programs.darling.enable = true;  # Run OSX binaries

  time.timeZone = "Pacific/Auckland";

  home-manager.users.adisbladis = { ... }: {
    home.stateVersion = "23.11";
    # Run xmodmap _after_ home-managers setxkbmap service, otherwise we'll get undone
    systemd.user.services.setxkbmap.Service.ExecStartPost = "${pkgs.xorg.xmodmap}/bin/xmodmap -e 'keycode 115 = Insert'";
  };

  services.xserver.libinput.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "kombu";

  boot.supportedFilesystems = [ "bcachefs" ];
  boot.kernelPackages = lib.mkOverride 0 pkgs.linuxPackages_testing_bcachefs;

  system.stateVersion = "23.11";
}
