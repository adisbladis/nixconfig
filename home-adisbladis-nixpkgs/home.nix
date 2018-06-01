{ pkgs, ... }:

let
  desktopEnvironment = pkgs.stdenv.mkDerivation rec {
    name = "desktop-environment-${version}";
    version = "2018-04-23";

    src = pkgs.fetchFromGitHub {
      owner = "DamienCassou";
      repo = "desktop-environment";
      rev = "62fbceded526b8e35c90803bcf80e33ebfe8473a";
      sha256 = "1j2kvdj3k9amj93w8cbh49rbf3vhnkbisw67hjhif62ajc19ip4k";
    };

    buildInputs = [ pkgs.emacs ];

    buildPhase = ''
      emacs --batch -f batch-byte-compile desktop-environment.el
    '';

    installPhase = ''
      mkdir -p $out/share/emacs/site-lisp
      cp desktop-environment.el desktop-environment.elc $out/share/emacs/site-lisp/
    '';

  };

in {
  # Emacs config
  home.file.".emacs".source = ./dotfiles/emacs/emacs;
  home.file.".config/emacs/config.org".source = ./dotfiles/emacs/config.org;

  home.packages = with pkgs; [
    ag
    ripgrep
    compton
    unclutter
    alacritty
    albert
    scrot
    breeze-qt5
    breeze-gtk
    rxvt_unicode-with-plugins
  ];

  # services.xscreensaver.enable = true;
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

  # Fix stupid java applications like android studio
  home.sessionVariables._JAVA_AWT_WM_NONREPARENTING = "1";

  services.compton = {
    enable = true;
  };

  xsession.enable = true;
  xsession.windowManager.command = ''
    rm ~/.config/emacs/config.el
    ${pkgs.networkmanagerapplet}/bin/nm-applet &
    ${pkgs.rxvt_unicode-with-plugins}/bin/urxvtd -q -o -f &
    env SHELL=$(which bash) emacs -f x11-wm-init
  '';

  # Fish config
  home.file.".config/fish/functions/fish_prompt.fish".source = ./dotfiles/fish/functions/fish_prompt.fish;
  home.file.".config/fish/functions/fish_right_prompt.fish".source = ./dotfiles/fish/functions/fish_right_prompt.fish;
  home.file.".config/fish/functions/ipython.fish".source = ./dotfiles/fish/functions/ipython.fish;
  home.file.".config/fish/functions/pcat.fish".source = ./dotfiles/fish/functions/pcat.fish;
  home.file.".config/fish/functions/pless.fish".source = ./dotfiles/fish/functions/pless.fish;
  home.file.".config/fish/functions/wgetpaste.fish".source = ./dotfiles/fish/functions/wgetpaste.fish;
  home.file.".config/fish/config.fish".source = ./dotfiles/fish/config.fish;

  home.file.".config/pulse/daemon.conf".source = ./dotfiles/pulse/daemon.conf;
  home.file.".config/mpv/mpv.conf".source = ./dotfiles/mpv/mpv.conf;

  services.syncthing = {
    enable = true;
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
  };

  home.sessionVariables.EDITOR = "emacsclient";
  home.sessionVariables.LESS = "-R";

  programs.browserpass.enable = true;

  programs.emacs = {
    enable = true;

    extraPackages = epkgs: [
      epkgs.pass
      epkgs.exwm
      epkgs.nix-mode
      epkgs.magit
      epkgs.zerodark-theme
      epkgs.jedi
      epkgs.fish-mode
      epkgs.jinja2-mode
      epkgs.lua-mode
      epkgs.irony
      epkgs.rust-mode
      epkgs.android-mode
      epkgs.markdown-mode
      epkgs.go-mode
      epkgs.yaml-mode
      epkgs.web-mode
      epkgs.nodejs-repl
      epkgs.company
      epkgs.elixir-mode
      epkgs.company-flx
      epkgs.company-statistics
      epkgs.company-go
      epkgs.ag
      epkgs.flx-ido
      epkgs.smooth-scrolling
      epkgs.swiper
      epkgs.webpaste
      epkgs.smart-mode-line
      epkgs.smart-mode-line-powerline-theme
      epkgs.flycheck
      epkgs.flycheck-irony
      epkgs.flycheck-mypy
      epkgs.flycheck-rust
      epkgs.flycheck-elixir
      epkgs.smartparens
      epkgs.direnv
      epkgs.js2-mode
      epkgs.ac-js2
      epkgs.ox-gfm
      epkgs.org
      epkgs.swift-mode
      epkgs.xref-js2
      (epkgs.melpaPackages.mocha.overrideAttrs(oldAttrs: {
        patches = [ ./mocha-inspect.patch ];
      }))
      epkgs.indium
      epkgs.protobuf-mode
      epkgs.blacken
      epkgs.emacs-libvterm
      epkgs.melpaPackages.emms
      (epkgs.melpaPackages.bongo.overrideAttrs(oldAttrs: {
        patches = pkgs.fetchpatch {
          url = "https://patch-diff.githubusercontent.com/raw/dbrock/bongo/pull/45.patch";
          sha256 = "08cvbvlplx42nks569si8wv0gp2d386ijvnrn360wpkcbf8zfwmf";
        };
      }))
      epkgs.melpaPackages.transmission
      epkgs.melpaPackages.terraform-mode
      desktopEnvironment
    ];
  };

  programs.git = {
    enable = true;
    userName = "adisbladis";
    userEmail = "adis@blad.is";
    signing.key = "FA75289B489AE1A51BCA18ABED58F95069B004F5";
    signing.signByDefault = true;
  };

  manual.manpages.enable = false;
}
