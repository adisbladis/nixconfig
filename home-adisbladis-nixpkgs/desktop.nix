{ pkgs, ... }:

let
  urxvtPackage = pkgs.rxvt_unicode-with-plugins;

  emacs = pkgs.callPackage ./emacs { };

in {

  nixpkgs.config.allowUnfree = true;

  # Emacs (exwm)
  home.file.".emacs".source = ./emacs/emacs.el;
  home.sessionVariables.EDITOR = "emacsclient";
  home.sessionVariables.XMODIFIERS = "@im=exim";
  home.sessionVariables.GTK_IM_MODULE = "xim";
  home.sessionVariables.QT_IM_MODULE = "xim";
  home.sessionVariables.CLUTTER_IM_MODULE = "xim";

  home.packages = with pkgs; [
    emacs
    firefox-devedition-bin
    scrot
    # gimp

    feh
    filelight
    (pass.withExtensions (ext: with ext; [
      pass-otp
      pass-update
    ]))
    graphviz
    unrar

    kcachegrind

    transmission_gtk
    darktable
    youtube-dl
    # mpv
    yubioath-desktop

    urxvtPackage
    yubioath-desktop
  ];

  services.blueman-applet.enable = true;

  services.pasystray.enable = true;

  services.flameshot.enable = true;

  services.kdeconnect = {
    enable = true;
    indicator = true;
  };

  home.file.".config/mpv/mpv.conf".source = ./dotfiles/mpv/mpv.conf;
  home.file.".Xresources".source = ./dotfiles/Xresources;

  programs.browserpass.enable = true;

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

  xsession.profileExtra = ''
    export XMODIFIERS=@im=exwm-xim
    export GTK_IM_MODULE=xim
    export QT_IM_MODULE=xim
    export CLUTTER_IM_MODULE=xim
    systemctl --user import-environment XMODIFIERS GTK_IM_MODULE QT_IM_MODULE CLUTTER_IM_MODULE
  '';

  # services.gnome-keyring.enable = true;

  # Notification daemon
  services.dunst.enable = true;
  services.dunst.settings = {
    global = {
      # font = "";

      # Allow a small subset of html markup
      markup = "yes";
      plain_text = "no";

      # The format of the message
      format = "<b>%s</b>\\n%b";

      # Alignment of message text
      alignment = "center";

      # Split notifications into multiple lines
      word_wrap = "yes";

      # Ignore newlines '\n' in notifications.
      ignore_newline = "no";

      # Hide duplicate's count and stack them
      stack_duplicates = "yes";
      hide_duplicates_count = "yes";

      # The geometry of the window
      geometry = "420x50-15+49";

      # Shrink window if it's smaller than the width
      shrink = "no";

      # Don't remove messages, if the user is idle
      idle_threshold = 0;

      # Which monitor should the notifications be displayed on.
      monitor = 0;

      # The height of a single line. If the notification is one line it will be
      # filled out to be three lines.
      line_height = 3;

      # Draw a line of "separatpr_height" pixel height between two notifications
      separator_height = 2;

      # Padding between text and separator
      padding = 6;
      horizontal_padding = 6;

      # Define a color for the separator
      separator_color = "frame";

      # dmenu path
      dmenu = "${pkgs.rofi}/bin/rofi -dmenu -p dunst -theme glue_pro_blue";

      # Browser for opening urls in context menu.
      browser = "/run/current-system/sw/bin/firefox -new-tab";

      # Align icons left/right/off
      icon_position = "left";
      max_icon_size = 80;

      # Define frame size and color
      frame_width = 3;
      frame_color = "#8EC07C";
    };

    shortcuts = {
      close = "ctrl+space";
      close_all = "ctrl+shift+space";
    };

    urgency_low = {
      frame_color = "#3B7C87";
      foreground = "#3B7C87";
      background = "#191311";
      timeout = 4;
    };
    urgency_normal = {
      frame_color = "#5B8234";
      foreground = "#5B8234";
      background = "#191311";
      timeout = 6;
    };

    urgency_critical = {
      frame_color = "#B7472A";
      foreground = "#B7472A";
      background = "#191311";
      timeout = 8;
    };
  };

  xsession.enable = true;
  xsession.windowManager.command = "emacs";

  services.screen-locker = {
    enable = true;
    lockCmd = "${pkgs.xsecurelock}/bin/xsecurelock";
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
