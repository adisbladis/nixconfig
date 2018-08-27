{ pkgs, ... }:

{

  home.file.".emacs".source = ./dotfiles/emacs.el;

  home.sessionVariables.EDITOR = "emacsclient";

  home.packages = with pkgs; [
    msmtp
  ];

  programs.emacs = {
    enable = true;

    extraPackages = epkgs: with epkgs; [
      pass
      exwm
      nix-mode
      zerodark-theme
      jedi
      fish-mode
      jinja2-mode
      lua-mode
      irony
      rust-mode
      android-mode
      markdown-mode
      go-mode
      yaml-mode
      web-mode
      nodejs-repl
      company
      elixir-mode
      company-flx
      company-statistics
      company-go
      ag
      flx-ido
      smooth-scrolling
      swiper
      webpaste
      smart-mode-line
      smart-mode-line-powerline-theme
      flycheck
      flycheck-irony
      flycheck-mypy
      flycheck-rust
      flycheck-elixir
      smartparens
      direnv
      js2-mode
      ac-js2
      ox-gfm
      org
      swift-mode
      xref-js2
      (melpaPackages.mocha.overrideAttrs(oldAttrs: {
        patches = [ ./mocha-inspect.patch ];
      }))
      indium
      protobuf-mode
      blacken
      emacs-libvterm
      use-package
      melpaPackages.emms
      melpaPackages.transmission
      melpaPackages.terraform-mode
      melpaPackages.kdeconnect
      melpaPackages.mpdel
      melpaPackages.notmuch
      melpaPackages.desktop-environment
      melpaPackages.weechat
      melpaPackages.dumb-jump
      melpaPackages.handlebars-mode
      (melpaPackages.magit-org-todos.overrideAttrs(oldAttrs: {
        buildInputs = oldAttrs.buildInputs ++ [ pkgs.git ];
      }))
      melpaPackages.magit
      melpaPackages.deadgrep
      melpaPackages.helm
      melpaPackages.helm-ag
      melpaPackages.helm-pass
      melpaPackages.helm-fuzzier
      melpaPackages.helm-projectile
      (melpaPackages.magit-todos.overrideAttrs(oldAttrs: {
        buildInputs = oldAttrs.buildInputs ++ [ pkgs.git ];
        src = pkgs.fetchFromGitHub {
          owner = "alphapapa";
          repo = "magit-todos";
          rev = "d12e2e3ccad4b87d5df5285ade0c56ec5f46ad63";
          sha256 = "006yy13hjzalwz7pz0br32zifxlxrrf8cvnz0j3km55sxpdvqmil";
        };
      }))
      sauron
    ];
  };

}
