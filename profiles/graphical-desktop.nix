{ stdenv, pkgs, lib, ... }:

let
  jailWrap = program: pkgs.writeScript "jailed" ''
    #!/usr/bin/env sh
    exec firejail --quiet "${program}" "$@"
  '';

in {
  imports = [ ./tkssh.nix ];

  nixpkgs.config.allowUnfree = true;

  # Sane font defaults
  fonts.enableFontDir = true;
  fonts.enableGhostscriptFonts = true;
  fonts.fontconfig.ultimate.enable = true;
  fonts.fontconfig.ultimate.preset = "osx";

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

  # programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    firefox-devedition-bin
    krunner-pass
    pavucontrol
    kdeconnect
    gwenview
    zip
    filelight
    (pass.withExtensions (ext: with ext; [ pass-otp pass-update ]))
    yakuake
    redshift
    graphviz
    emacs-all-the-icons-fonts
    unzip
    mpv
    wireshark
    transmission_gtk
    darktable
    okular
    redshift-plasma-applet
    direnv
    android-studio
    youtube-dl
    qsyncthingtray

    # Needs to be present both in security.wrappers and systemPackages for desktop files
    spotify
    gimp
    kate
  ];

  # Enable pulse with all the modules
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;

  # Enable the fw update manager
  services.fwupd.enable = true;

  programs.browserpass.enable = true;
  programs.simpleserver.enable = true;
  programs.adb.enable = true;

  security.wrappers = with pkgs; {
    firejail.source = "${firejail.out}/bin/firejail";
    gimp.source = jailWrap "${gimp.out}/bin/gimp";
    unrar.source = jailWrap "${unrar.out}/bin/unrar";
    kate.source = jailWrap "${kate.out}/bin/kate";
  };

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
  services.xserver.layout = "se";
  services.xserver.xkbOptions = "eurosign:e";
  services.xserver.xkbVariant = "dvorak";

  services.xserver.displayManager.sddm.enable = true;
  services.xserver.displayManager.sddm.autoLogin.enable = true;
  services.xserver.displayManager.sddm.autoLogin.user = "adisbladis";

  services.xserver.desktopManager.plasma5.enableQt4Support = false;
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.desktopManager.xterm.enable = false;

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
  services.unbound.enable = true;

  users.extraUsers.adisbladis.extraGroups = [ "wheel" "networkmanager" "adbusers" "wireshark" ];
}
