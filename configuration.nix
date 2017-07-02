# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./nixpkgs/nixos/modules/profiles/hardened.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only
  fileSystems."/".options = ["noatime" "nodiratime" "discard" "compress=lzo"];
  fileSystems."/tmp" = {
    mountPoint = "/tmp";
    device = "tmpfs";
    fsType = "tmpfs";
    options = ["nosuid" "nodev" "relatime"];
  };

  # KSPP kernel
  boot.kernelPackages = pkgs.linuxPackages_hardened_copperhead;
  security.lockKernelModules = false;  # No wifi with this one enabled

  # Use local nixpkgs checkout
  nix.nixPath = [ "/etc/nixos" "nixos-config=/etc/nixos/configuration.nix" ];

  hardware = {
    cpu.intel.updateMicrocode = true;
    pulseaudio.enable = true;
    trackpoint.enable = true;
  };

  # TODO: Svorak package
  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # Set your time zone.
  time.timeZone = "Asia/Hong_Kong";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    gparted
    fish
    gnupg
    emacs
    wget
    htop
    mosh
    git
    screen
    tmux
    debootstrap
    libu2f-host
    firejail
  ];

  # Setuid wrappers
  security.wrappers = {
    firejail.source = "${pkgs.firejail.out}/bin/firejail";
  };

  fonts.fontconfig.ultimate.enable = true;

  services = {
    tlp.enable = true;
    avahi.enable = true;
    printing.enable = true;

    pcscd.enable = true;
    udev.packages = [ pkgs.libu2f-host ];

    xserver = {
      enable = true;
      layout = "se";
      xkbOptions = "eurosign:e";
      xkbVariant = "dvorak";

      videoDrivers = ["intel" "modesetting"];

      displayManager.sddm.enable = true;
      desktopManager.plasma5.enable = true;
      desktopManager.xterm.enable = false;

      synaptics = {
        enable = true;
      	additionalOptions = ''
	  Option "SoftButtonAreas" "50% 0 82% 0 0 0 0 0"
	  Option "SecondarySoftButtonAreas" "58% 0 0 15% 42% 58% 0 15%"
	  Option "LeftEdge"		      "1"
	  Option "RightEdge"			"2"
	  Option "VertEdgeScroll"				"1"
	  Option "AreaTopEdge"					"2500"
	'';
      };

    };
  };

  # Open ports in the firewall.
  networking = {
    firewall.enable = true;
    # 1714-1764 is KDE connect, 8000 is file serving
    firewall.allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
    firewall.allowedUDPPortRanges = [ { from = 1714; to = 1764; } ];
    firewall.allowedTCPPorts = [8000];
    networkmanager.enable = true;
    hostName = "gari-nixos";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.adisbladis = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.fish;
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "17.09";

}
