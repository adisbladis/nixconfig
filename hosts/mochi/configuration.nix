{ config, pkgs, lib, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../modules
    ];

  my.ephemeral-root.enable = true;
  my.laptop.enable = true;
  my.gaming.enable = true;
  my.mullvad.enable = true;

  services.xserver.dpi = 140;

  services.xserver.videoDrivers = lib.mkForce [
    "amdgpu"
    "dummy" # For xpra
  ];

  # acpi_call makes tlp work for newer thinkpads
  boot.kernelModules = [ "acpi_call" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.acpi_call ];

  # acpi_backlight=none allows the backlight save/load systemd service to work.
  boot.kernelParams = [ "acpi_backlight=none" ];

  time.timeZone = "America/Los_Angeles";

  home-manager.users.adisbladis = { ... }: {

    # Run xmodmap _after_ home-managers setxkbmap service, otherwise we'll get undone
    systemd.user.services.setxkbmap.Service.ExecStartPost = "${pkgs.xorg.xmodmap}/bin/xmodmap -e 'keycode 115 = Insert'";

    # = "${pkgs.writeShellScript "xkbmap-post" (lib.concatStringsSep "\n" [
    #   # Fix trackpoint acceleration
    #   "xinput --set-prop 'TPPS/2 Elan TrackPoint' 'Device Accel Constant Deceleration' 0.4"
    #   # Remap end/insert combo key to insert
    #   "${pkgs.xorg.xmodmap}/bin/xmodmap -e 'keycode 115 = Insert'"
    # ])}";
  };

  # Make trackpad act as scroll wheel
  hardware.trackpoint.enable = true;
  services.xserver.synaptics.enable = true;
  services.xserver.synaptics.additionalOptions = ''
    Option "LeftEdge"  "46"
    Option "RightEdge"  "47"
    Option "VertEdgeScroll"  "1"
  '';

  hardware.cpu.amd.updateMicrocode = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "mochi";
  networking.hostId = "a5ece915";

  # Don't downgrade to pre 5.15 kernels, but use latest compatible kernel for zfs
  boot.kernelPackages =
    if lib.versionAtLeast config.boot.zfs.package.latestCompatibleLinuxPackages.kernel.version "5.15"
    then config.boot.zfs.package.latestCompatibleLinuxPackages
    else pkgs.linuxPackages_latest;

  system.stateVersion = "21.11";
}
