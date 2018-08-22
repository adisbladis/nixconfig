{ pkgs, ... }:

let
  urxvtPackage = pkgs.rxvt_unicode-with-plugins;

in {

  home.packages = with pkgs; [
    firefox-devedition-bin
    urxvtPackage
    notmuch
    scrot
    spotify
    gimp

    feh
    filelight
    (pass.withExtensions (ext: with ext; [
      pass-otp
      pass-update
    ]))
    graphviz
    unrar

    pavucontrol
    transmission_gtk
    darktable
    # wireshark
    android-studio
    youtube-dl
    qt5ct
    mpv
  ];

  services.flameshot.enable = true;

  programs.autorandr.enable = true;

  services.kdeconnect = {
    enable = true;
    indicator = true;
  };

  home.file.".config/pulse/daemon.conf".source = ./dotfiles/pulse/daemon.conf;
  home.file.".config/mpv/mpv.conf".source = ./dotfiles/mpv/mpv.conf;

  services.mbsync = with pkgs; {
    preExec = "${coreutils}/bin/mkdir -p %h/Maildir/adisbladis-gmail";
    postExec = "${notmuch}/bin/notmuch new";
    enable = true;
  };

  services.syncthing.enable = true;

  programs.browserpass.enable = true;

  home.sessionVariables.EDITOR = "emacsclient";

  services.compton.enable = true;

  # Needed for wifi password input
  services.network-manager-applet.enable = true;

  # Make icons work in network-manager-applet
  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.hicolor_icon_theme;
      name = "hicolor";
    };
  };
  # And make QT look the same
  qt = {
    useGtkTheme = true;
    enable = true;
  };

  services.gnome-keyring.enable = true;

  # Notification daemon
  services.dunst.enable = true;

  # services.blueman-applet.enable = true;

  xsession.enable = true;
  xsession.windowManager.command = ''
    # Speed up terminal startup
    # This needs to run in the desktop session for child
    # processes (shells etc) to also run in the session
    ${urxvtPackage}/bin/urxvtd -q -o -f &

    ${pkgs.adis-applauncher}/bin/applauncher &

    # Shell needs to be bash :(
    env SHELL=$(which bash) emacs -f x11-wm-init
  '';

  services.screen-locker = {
    enable = true;
    lockCmd = "${pkgs.i3lock}/bin/i3lock -n -c 000000";
  };

  services.unclutter = {
    enable = true;
    timeout = 5;
  };

  home.keyboard = {
    variant = "dvorak";
    layout = "us";
    options = [
      "ctrl:nocaps"
    ];
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
  };

  # Fix stupid java applications like android studio
  home.sessionVariables._JAVA_AWT_WM_NONREPARENTING = "1";

  programs.git.signing.signByDefault = true;

}
