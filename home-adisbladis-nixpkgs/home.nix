{ pkgs, ... }:

{
  # Emacs config
  home.file.".emacs".source = ./dotfiles/emacs/emacs;
  home.file.".config/emacs/config.org".source = ./dotfiles/emacs/config.org;

  home.packages = with pkgs; [ ag ripgrep ];

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

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
  };

  home.sessionVariables.EDITOR = "emacs";
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
