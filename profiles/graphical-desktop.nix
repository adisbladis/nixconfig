{ stdenv, pkgs, lib, ... }:

{
  imports = [
    ../home-adisbladis-nixpkgs/home-manager/nixos
  ];

  nixpkgs.config.allowUnfree = true;

  # Sane font defaults
  fonts.enableFontDir = true;
  fonts.enableGhostscriptFonts = true;

  fonts.fonts = with pkgs; [
    liberation_ttf
    inconsolata
    dejavu_fonts
    emacs-all-the-icons-fonts
    powerline-fonts
    source-code-pro
  ];

  boot.supportedFilesystems = [
    "exfat"
  ];

  # Gtk3 apps seems to require dconf... :/
  programs.dconf.enable = true;

  # setuid wrapper for backlight
  programs.light.enable = true;

  environment.systemPackages = with pkgs; [
    emacs-all-the-icons-fonts
    bulkrecode
    spotify
    dolphin  # GUI file browser for stupid drag & drop web apps
    electrum  # BTC wallet
    tor-browser-bundle-bin
    mpv
  ];

  # Enable pulse with all the modules
  hardware.pulseaudio = {
    enable = true;
    extraModules = [ pkgs.pulseaudio-modules-bt ];

    daemon.config = {
      flat-volumes = "no";
      default-sample-format = "s24le";
      default-sample-rate = "192000";
      avoid-resampling = "true";
    };

    package = pkgs.pulseaudioFull;
  };

  programs.firejail.enable = true;

  programs.browserpass.enable = true;
  programs.simpleserver.enable = true;
  programs.adb.enable = true;

  services.udev.extraRules = ''
    # Meizu Pro 5
    SUBSYSTEM=="usb", ATTR{idVendor}=="2a45", MODE="0666", GROUP="adbusers"

    # Ledger nano S
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="2c97", ATTRS{idProduct}=="0001", MODE="0660", TAG+="uaccess", TAG+="udev-acl"
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0660", GROUP="adbusers", ATTRS{idVendor}=="2c97"
  '';

  services.avahi.enable = true;

  services.printing.enable = true;
  services.printing.drivers = [ pkgs.gutenprint ];

  services.pcscd.enable = true;
  hardware.u2f.enable = true;
  services.xserver.enable = true;

  services.xserver.layout = "us";
  services.xserver.xkbOptions = "ctrl:nocaps";
  services.xserver.xkbVariant = "dvorak";

  services.xserver.displayManager.slim.enable = true;
  services.xserver.displayManager.slim.autoLogin = true;
  services.xserver.displayManager.slim.defaultUser = "adisbladis";

  networking.firewall.allowedTCPPortRanges = [
    # KDE connect
    { from = 1714; to = 1764; }
  ];
  networking.firewall.allowedUDPPortRanges = [
    # KDE connect
    { from = 1714; to = 1764; }
  ];
  networking.firewall.allowedTCPPorts = [
    8000  # http server
    24800  # synergy
    22000  # Syncthing
  ];
  networking.firewall.allowedUDPPorts = [
    21027  # Syncthing discovery
  ];
  networking.networkmanager.enable = true;

  services.unbound = {
    enable = true;
    extraConfig = ''
      forward-zone:
        name: "."
        forward-addr: 8.8.8.8
        forward-addr: 8.8.4.4
    '';
  };

  # TODO: Make a "meta" home-manager module that can merge multiple files
  home-manager.users.adisbladis = import ../home-adisbladis-nixpkgs/home.nix;

  users.extraUsers.adisbladis.extraGroups = [ "wheel" "networkmanager" "adbusers" "wireshark" ];
}
