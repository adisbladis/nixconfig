{ pkgs, ... }:

{

  # Emacs config
  home.file.".emacs".source = ./dotfiles/emacs/emacs;
  home.file.".config/emacs/config.org".source = ./dotfiles/emacs/config.org;

  # Fish config
  home.file.".config/fish/config.fish".source = ./dotfiles/fish/config.fish;
  home.file.".config/fish/functions/fish_prompt.fish".source = ./dotfiles/fish/functions/fish_prompt.fish;
  home.file.".config/fish/functions/fish_right_prompt.fish".source = ./dotfiles/fish/functions/fish_right_prompt.fish;
  home.file.".config/fish/functions/ipython.fish".source = ./dotfiles/fish/functions/ipython.fish;
  home.file.".config/fish/functions/pcat.fish".source = ./dotfiles/fish/functions/pcat.fish;
  home.file.".config/fish/functions/pless.fish".source = ./dotfiles/fish/functions/pless.fish;

  home.file.".config/pulse/daemon.conf".source = ./dotfiles/pulse/daemon.conf;
  home.file.".config/mpv/mpv.conf".source = ./dotfiles/mpv/mpv.conf;

  home.packages = [
    pkgs.gimp
    pkgs.kdeconnect
    pkgs.youtube-dl
    pkgs.pavucontrol
    pkgs.pass
    pkgs.graphviz
    pkgs.jq
    pkgs.yakuake
    pkgs.mpv
    pkgs.android-studio
    pkgs.wireshark
    pkgs.redshift
    pkgs.acpi
    pkgs.sshfs-fuse
    pkgs.inconsolata
    pkgs.liberation_ttf
    pkgs.dnsutils
    pkgs.skypeforlinux
    pkgs.spotify
    pkgs.okular
    pkgs.redshift-plasma-applet
    pkgs.rustChannels.nightly.rust
    (import "/etc/nixos/nixpkgs-mozilla/" {}).firefox-nightly-bin
  ];

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };

  programs.browserpass.enable = true;

  programs.emacs = {
    enable = true;
    extraPackages = epkgs: [
      epkgs.nix-mode
      epkgs.magit
      epkgs.zerodark-theme
      pkgs.python36
      pkgs.python36Packages.jedi
      pkgs.python36Packages.epc
      pkgs.python36Packages.virtualenv
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
      epkgs.company
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
      epkgs.smartparens
      pkgs.emacs-all-the-icons-fonts
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
