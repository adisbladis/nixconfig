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
    pkgs.mullvad-vpn
  ];

  services.xserver.dpi = 140;

  boot.kernelModules = [
    "amd-pstate"
    "acpi_call"
  ];

  boot.extraModulePackages = [ config.boot.kernelPackages.acpi_call ];

  boot.kernelParams = [
    "initcall_blacklist=acpi_cpufreq_init"
    "amd_pstate.shared_mem=1"

    # acpi_backlight=none allows the backlight save/load systemd service to work.
    "acpi_backlight=none"

    # Allow turbo boost
    "processor.ignore_ppc=1"
  ];

  services.mullvad-vpn.enable = true;

  time.timeZone = "Asia/Hong_Kong";

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
