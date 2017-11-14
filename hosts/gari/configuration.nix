# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../profiles/common.nix
      ../../profiles/graphical-desktop.nix
      ../../profiles/laptop.nix
    ];

  boot.kernelPackages = pkgs.linuxPackages_4_13;

  boot.initrd.supportedFilesystems = ["zfs"];
  boot.zfs.enableUnstable = true;
  boot.supportedFilesystems = ["ext4" "btrfs" "zfs"];

  networking.hostName = "gari-nixos";
  networking.hostId = "a8c06608";

  virtualisation.docker.enable = true;
  nixpkgs.config.allowBroken = true;

  services.xserver.synaptics.additionalOptions = ''
   Option "SoftButtonAreas" "50% 0 82% 0 0 0 0 0"
	Option "SecondarySoftButtonAreas" "58% 0 0 15% 42% 58% 0 15%"
	Option "LeftEdge"		      "1"
	Option "RightEdge"			"2"
	Option "VertEdgeScroll"				"1"
	Option "AreaTopEdge"					"2500"
 '';
  services.xserver.videoDrivers = ["modesetting"];
  hardware.cpu.intel.updateMicrocode = true;

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/disk/by-id/ata-INTEL_SSDSC2BW480A3L_CVCV316405HA480DGN"; # or "nodev" for efi only
  fileSystems."/".options = ["noatime" "nodiratime"];
  fileSystems."/tmp" = {
    mountPoint = "/tmp";
    device = "tmpfs";
    fsType = "tmpfs";
    options = ["nosuid" "nodev" "relatime"];
  };
}
