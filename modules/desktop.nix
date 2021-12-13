{ config, lib, pkgs, ... }:

let
  cfg = config.my.desktop;

in
{

  options.my.desktop.enable = lib.mkEnableOption "Enable common desktop options.";

  config = lib.mkIf cfg.enable {

    my.podman.enable = true;
    my.spell.enable = true;
    my.sound.enable = true;
    my.firefox.enable = true;
    my.exwm.enable = true;

    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryFlavor = "qt";
    };

    fonts.fonts = [
      pkgs.liberation_ttf
      pkgs.inconsolata
      pkgs.dejavu_fonts
      pkgs.emacs-all-the-icons-fonts
      pkgs.powerline-fonts
      pkgs.source-code-pro
    ];

    boot.supportedFilesystems = [
      "exfat" # External drives
    ];

    # Gtk3 apps seems to require dconf... :/
    programs.dconf.enable = true;

    security.wrappers.paperlike-cli = {
      owner = "root";
      group = "root";
      source = "${pkgs.paperlike-go}/bin/paperlike-cli";
    };

    security.pam.loginLimits = [
      {
        domain = "*";
        type = "soft";
        item = "nofile";
        value = "8192";
      }
    ];

    environment.systemPackages = [
      pkgs.paperlike-go
      pkgs.alsaUtils
      pkgs.emacs-all-the-icons-fonts
      pkgs.libva-utils
    ];

    services.dbus.packages = [
      pkgs.gcr # Make pinentry for keyring work
    ];

    programs.adb.enable = true;

    services.printing.enable = true;
    services.printing.drivers = [ pkgs.gutenprint ];

    services.pcscd.enable = true;

    hardware.opengl.enable = true;
    hardware.opengl.driSupport = true;

    hardware.openrazer = {
      enable = true;
      users = [ "adisbladis" ];
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
      8000 # http server
      24800 # synergy
      22000 # Syncthing
    ];
    networking.firewall.allowedUDPPorts = [
      21027 # Syncthing discovery
    ];
    networking.networkmanager.enable = true;

    # Touch screen in firefox
    environment.variables.MOZ_USE_XINPUT2 = "1";

    services.resolved.enable = true;

    home-manager.users.adisbladis = { ... }: {
      xsession.pointerCursor = {
        package = pkgs.vanilla-dmz;
        name = "Vanilla-DMZ-AA";
      };


      programs.direnv.enable = true;
      programs.direnv.nix-direnv.enable = true;

      programs.git = {
        enable = true;
        userName = "adisbladis";
        userEmail = "adisbladis@gmail.com";
        signing.key = "00244EF5295026AA323A4BDB110BFAD44C6249B7";
      };

      manual.manpages.enable = false;

      # Touch screen in firefox
      home.sessionVariables.MOZ_USE_XINPUT2 = "1";
      xsession.importedVariables = [
        "MOZ_USE_XINPUT2"
      ];

      # Matrix client
      services.pantalaimon = {
        enable = true;
        settings = {
          Default = {
            LogLevel = "Debug";
            SSL = true;
          };
          "blad.is" = {
            Homeserver = "https://matrix.blad.is";
            ListenAddress = "127.0.0.1";
            ListenPort = 8008;
          };
        };
      };

      services.pasystray.enable = true;

      services.flameshot.enable = true;

      services.kdeconnect = {
        enable = true;
        indicator = true;
      };

      home.file.".config/mpv/mpv.conf".source = pkgs.writeText "mpv.conf" ''
        # profile=opengl
        # scale=ewa_lanczossharp
        # cscale=ewa_lanczossharp
        # scaler-resizes-only
        # hwdec=vaapi
        # interpolation=yes
        # tscale=oversample
        # video-sync=display-resample
        hwdec=vaapi
        vo=gpu
        hwdec-codecs=all
        volume-max=200
        no-audio-display
        ao=pulse

        # Always use 1080p+ or 60 fps where available. Prefer VP9
        # over AVC and VP8 for high-resolution streams.
        ytdl=yes
        ytdl-format=(bestvideo[ext=webm]/bestvideo[height>720]/bestvideo[fps=60])[tbr<13000]+(bestaudio[acodec=opus]/bestaudio[ext=webm]/bestaudio)/best
      '';

      programs.browserpass.enable = true;

      services.picom = {
        enable = true;
        vSync = true;
      };

      # Needed for wifi password input
      services.network-manager-applet.enable = true;

      systemd.user.startServices = true;

      services.gnome-keyring.enable = true;

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

      home.packages = (
        let
          # Link into ipythonEnv package to avoid polluting $PATH with python deps
          ipythonPackage =
            let
              ipythonEnv = (pkgs.python3.withPackages (ps: [
                ps.ipython
                ps.requests
                ps.psutil
                ps.nixpkgs
              ]));
            in
            pkgs.runCommand "ipython-stripped" { } ''
              mkdir -p $out/bin
              ln -s ${ipythonEnv}/bin/ipython $out/bin/ipython
            '';
        in
        [
          ipythonPackage
        ] ++ [
          pkgs.traceroute
          pkgs.whois
          pkgs.nmap
          pkgs.unzip
          pkgs.zip
          pkgs.librespot
          pkgs.scrot
          pkgs.gimp
          pkgs.feh
          pkgs.filelight
          (pkgs.pass.withExtensions (ext: [
            ext.pass-otp
            ext.pass-update
            ext.pass-checkup
          ]))
          pkgs.graphviz
          pkgs.unrar
          pkgs.gopls # Go language server
          pkgs.rls # Rust language server
          pkgs.kcachegrind
          pkgs.transmission_gtk
          pkgs.darktable
          pkgs.youtube-dl
          pkgs.yubioath-desktop
          pkgs.sshfs-fuse
          pkgs.dolphin # GUI file browser for stupid drag & drop web apps
          pkgs.mpv
          pkgs.ffmpeg
          pkgs.qemu
        ]
      );

    };

    users.users.adisbladis.extraGroups = [ "plugdev" "networkmanager" "adbusers" "wireshark" "video" ];
  };

}
