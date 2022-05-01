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

  environment.systemPackages = [
    pkgs.ryzenadj
  ];

  services.xserver.dpi = 140;

  # acpi_call makes tlp work for newer thinkpads
  boot.kernelModules = [ "acpi_call" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.acpi_call ];

  boot.kernelParams = [

    # acpi_backlight=none allows the backlight save/load systemd service to work.
    "acpi_backlight=none"

    # Allow turbo boost
    "processor.ignore_ppc=1"

  ];

  time.timeZone = "Pacific/Fiji";

  home-manager.users.adisbladis = { ... }: {

    home.stateVersion = "22.05";

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

  boot.kernelPackages = pkgs.zfs.latestCompatibleLinuxPackages;

  system.stateVersion = "22.05";
}
