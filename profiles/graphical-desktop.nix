{ stdenv, pkgs, ... }:

{
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

  environment.systemPackages = with pkgs; [
    libu2f-host
    okular
    redshift-plasma-applet
    pavucontrol
    kdeconnect
    gimp
    youtube-dl
    pass
    mpv
    yakuake
    wireshark
    redshift
    firejail
    graphviz
    emacs-all-the-icons-fonts
    firefox
    # Requires unfree
    spotify
    android-studio
  ];

  security.wrappers = {
    firejail.source = "${pkgs.firejail.out}/bin/firejail";
    android-studio.source = "${pkgs.android-studio.out}/bin/android-studio";
  };

  services.avahi.enable = true;
  services.printing.enable = true;
  services.pcscd.enable = true;
  services.udev.packages = [ pkgs.libu2f-host ];
  services.xserver.enable = true;
  services.xserver.layout = "se";
  services.xserver.xkbOptions = "eurosign:e";
  services.xserver.xkbVariant = "dvorak";

  services.xserver.displayManager.sddm.enable = true;
  services.xserver.displayManager.sddm.autoLogin.enable = true;
  services.xserver.displayManager.sddm.autoLogin.user = "adisbladis";

  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.desktopManager.xterm.enable = false;

  # 1714-1764 is KDE connect, 8000 is file serving
  networking.firewall.allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
  networking.firewall.allowedUDPPortRanges = [ { from = 1714; to = 1764; } ];
  networking.firewall.allowedTCPPorts = [8000];
  networking.networkmanager.enable = true;

  users.extraUsers.adisbladis.extraGroups = [ "wheel" "networkmanager" ];
}
