{ config, pkgs, lib, ... }:

let
  cfg = config.my.common-graphical;

in {

  options.my.common-graphical.enable = lib.mkEnableOption "Enables my common CLI thingies.";

  config = lib.mkIf cfg.enable {

    boot.kernelPackages = pkgs.linuxPackages_latest;

    nixpkgs.config.allowUnfree = true;

    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryFlavor = "qt";
    };

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
      "exfat"  # External drives
    ];

    # Gtk3 apps seems to require dconf... :/
    programs.dconf.enable = true;

    # setuid wrapper for backlight
    programs.light.enable = true;

    environment.systemPackages = [
      pkgs.emacs-all-the-icons-fonts
      pkgs.libva-utils
    ];

    # Enable pulse with all the modules
    hardware.pulseaudio = {
      enable = true;
      daemon.config = {
        flat-volumes = "no";
        default-sample-format = "s24le";
        default-sample-rate = "192000";
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

    services.xserver.displayManager.defaultSession = "none+xsession";

    services.xserver.displayManager.lightdm.enable = true;
    services.xserver.displayManager.lightdm.autoLogin.enable = true;
    services.xserver.displayManager.lightdm.autoLogin.user = "adisbladis";

    services.xserver.videoDrivers = [
      "dummy"  # For xpra
    ];

    hardware.opengl.enable = true;
    hardware.opengl.driSupport = true;

    # Set up the login session
    services.xserver.windowManager.session = lib.singleton {
      name = "xsession";
      start = pkgs.writeScript "xsession" ''
        #!${pkgs.runtimeShell}
        if test -f $HOME/.xsession; then
          exec ${pkgs.runtimeShell} -c $HOME/.xsession
        else
          echo "No xsession script found"
          exit 1
        fi
      '';
    };

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
    networking.networkmanager.wifi.backend = "iwd";

    # Touch screen in firefox
    environment.variables.MOZ_USE_XINPUT2 = "1";

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
    home-manager.users.adisbladis = { ... }:

    {

      # Emacs (exwm)
      home.file.".emacs".source = ../home-adisbladis-nixpkgs/emacs/emacs.el;
      home.sessionVariables.EDITOR = "emacsclient";
      home.sessionVariables.XMODIFIERS = "@im=exim";
      home.sessionVariables.GTK_IM_MODULE = "xim";
      home.sessionVariables.QT_IM_MODULE = "xim";
      home.sessionVariables.CLUTTER_IM_MODULE = "xim";

      home.packages = with pkgs; [
        firefox-devedition-bin
        scrot
        # gimp

        feh
        filelight
        (pass.withExtensions (ext: [
          ext.pass-otp
          ext.pass-update
          ext.pass-checkup
        ]))
        graphviz
        unrar

        kcachegrind

        transmission_gtk
        darktable
        youtube-dl
        yubioath-desktop
        sshfs-fuse

        rxvt_unicode-with-plugins

        spotify
        bulkrecode
        dolphin  # GUI file browser for stupid drag & drop web apps
        electrum  # BTC wallet
        tor-browser-bundle-bin
        mpv
      ];

      services.pasystray.enable = true;

      services.flameshot.enable = true;

      services.kdeconnect = {
        enable = true;
        indicator = true;
      };

      home.file.".config/mpv/mpv.conf".source = ../home-adisbladis-nixpkgs/dotfiles/mpv/mpv.conf;
      home.file.".Xresources".source = ../home-adisbladis-nixpkgs/dotfiles/Xresources;

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

      # Fix stupid java applications like android studio
      home.sessionVariables._JAVA_AWT_WM_NONREPARENTING = "1";

      programs.git.signing.signByDefault = true;

    };

    users.users.adisbladis.extraGroups = [ "plugdev" "networkmanager" "adbusers" "wireshark" "video" ];

  };

}
