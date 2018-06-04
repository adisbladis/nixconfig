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

  home.file.".emacs".source = ./dotfiles/emacs/emacs;
  home.file.".config/emacs/config.org".source = ./dotfiles/emacs/config.org;

  home.sessionVariables.EDITOR = "emacsclient";

  home.packages = with pkgs; [
    msmtp
  ];

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
      epkgs.melpaPackages.kdeconnect
      epkgs.melpaPackages.mpdel
      epkgs.melpaPackages.notmuch
      desktopEnvironment
      epkgs.melpaPackages.weechat
    ];
  };

}
