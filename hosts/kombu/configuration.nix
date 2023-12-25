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

  time.timeZone = "Pacific/Auckland";

  # Overclock EPYC
  boot.kernelModules = [ "msr" ];
  systemd.services.zenstates = let
    zenstates = let
      src = pkgs.fetchFromGitHub {
        owner = "r4m0n";
        repo = "ZenStates-Linux";
        rev = "0bc27f4740e382f2a2896dc1dabfec1d0ac96818";
        sha256 = "1h1h2n50d2cwcyw3zp4lamfvrdjy1gjghffvl3qrp6arfsfa615y";
      };
    in pkgs.runCommand "zenstates" { buildInputs = [ pkgs.python3 ]; } ''
      mkdir -p $out/bin
      cp ${src}/zenstates.py $out/bin/zenstates
      chmod +x $out/bin/zenstates
      patchShebangs $out/bin/zenstates
    '';
  in {
    description = "Dynamically edit AMD Ryzen/EPYC processor P-States";
    serviceConfig = {
      # Note: Overclocks P0 state to:
      # P0 - Enabled - FID = 40 - DID = 4 - VID = 49 - Ratio = 32.00 - vCore = 1.09375
      ExecStart = "${zenstates}/bin/zenstates -p 0 -f 40 -v 49 -d 4";
      Type = "oneshot";
    };
    wantedBy = [ "multi-user.target" ];
  };

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
  boot.kernelPackages = pkgs.linuxPackages_testing;

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
