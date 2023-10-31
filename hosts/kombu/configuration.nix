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

    home.packages = [ pkgs.ktouch ];

    # No time-based screen locker on the desktop computer.
    services.screen-locker.xautolock.enable = false;

  };

  services.xserver.libinput.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "kombu";

  boot.supportedFilesystems = [ "bcachefs" ];
  boot.kernelPackages = lib.mkOverride 0 pkgs.linuxPackages_testing_bcachefs;

  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  networking.hostId = "c3f288e3";

  programs.fuse.userAllowOther = true;

  services.transmission = {
    enable = true;
    settings.download-dir = "/media/torrent";
  };
  systemd.services.transmission.serviceConfig.BindPaths = [ "/media" ];

  services.radarr = {
    enable = true;
    openFirewall = true;
  };

  environment.persistence."/persistent" = {
    users.adisbladis = {
      directories = [
        ".local/share/ktouch"
      ];
    };

    directories = [
      {
        directory = "/var/lib/jellyfin";
        mode = "0700";
        user = "jellyfin";
        group = "jellyfin";
      }

      {
        directory = "/var/lib/transmission";
        mode = "0770";
        user = "transmission";
        group = "transmission";
      }

      {
        directory = "/var/lib/radarr";
        mode = "0770";
        user = "radarr";
        group = "radarr";
      }
    ];
  };

  hardware.opengl.extraPackages = [
    pkgs.vaapiVdpau
    pkgs.libvdpau-va-gl
    pkgs.amdvlk

    pkgs.rocm-opencl-icd
    pkgs.rocm-opencl-runtime
  ];

  environment.systemPackages = [
    pkgs.clinfo
    pkgs.rar2fs
    pkgs.tailscale
  ];

  services.tailscale.enable = true;

  system.stateVersion = "23.11";
}
