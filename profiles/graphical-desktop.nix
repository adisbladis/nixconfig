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
  ];

  virtualisation.virtualbox.host.enable = true;

  hardware.pulseaudio.enable = true;

  environment.systemPackages = with pkgs; [
    libu2f-host
    pavucontrol
    kdeconnect
    gwenview
    zip
    filelight
    pass
    yakuake
    redshift
    graphviz
    emacs-all-the-icons-fonts
    unzip

    # Needs to be present both in security.wrappers and systemPackages for desktop files
    transmission_gtk
    firefox-devedition-bin
    wireshark
    spotify
    okular
    gimp
    kate
  ];

  programs.simpleserver.enable = true;
  programs.adb.enable = true;

  security.wrappers = with pkgs; {
    firejail.source = "${firejail.out}/bin/firejail";
    # firefox.source = jailWrap "${firefox-devedition-bin.out}/bin/firefox";
    transmission-gtk.source = jailWrap "${transmission_gtk.out}/bin/transmission-gtk";
    youtube-dl.source = jailWrap "${youtube-dl.out}/bin/youtube-dl";
    mpv.source = jailWrap "${mpv.out}/bin/mpv";
    gimp.source = jailWrap "${gimp.out}/bin/gimp";
    unrar.source = jailWrap "${unrar.out}/bin/unrar";
    wireshark.source = jailWrap "${wireshark.out}/bin/wireshark";
    kate.source = jailWrap "${kate.out}/bin/kate";
    okular.source = jailWrap "${okular.out}/bin/okular";
    arduino.source = jailWrap "${arduino.out}/bin/arduino";
    darktable.source = jailWrap "${darktable.out}/bin/darktable";
    gwenview.source = jailWrap "${gwenview.out}/bin/gwenview";
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
  services.udev.packages = [ pkgs.libu2f-host ];
  services.xserver.enable = true;
  services.xserver.layout = "se";
  services.xserver.xkbOptions = "eurosign:e";
  services.xserver.xkbVariant = "dvorak";

  services.xserver.displayManager.sddm.enable = true;
  services.xserver.displayManager.sddm.autoLogin.enable = true;
  services.xserver.displayManager.sddm.autoLogin.user = "adisbladis";

  environment.variables.QT_PLUGIN_PATH = [ "${pkgs.plasma-desktop}/lib/qt-5.9/plugins/kcms" ];
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.desktopManager.xterm.enable = false;

  # 1714-1764 is KDE connect, 8000 is file serving
  networking.firewall.allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
  networking.firewall.allowedUDPPortRanges = [ { from = 1714; to = 1764; } ];
  networking.firewall.allowedTCPPorts = [8000];
  networking.networkmanager.enable = true;
  services.unbound.enable = true;

  users.extraUsers.adisbladis.extraGroups = [ "wheel" "networkmanager" "adbusers" ];
}
