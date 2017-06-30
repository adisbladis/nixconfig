{ pkgs, ... }:

{

  home.packages = [
    pkgs.gimp
    pkgs.kdeconnect
    pkgs.youtube-dl
    pkgs.pavucontrol
    pkgs.pass
    pkgs.browserpass
    pkgs.graphviz
    pkgs.jq
    pkgs.yakuake
    pkgs.mpv
    pkgs.android-studio
    pkgs.wireshark
    pkgs.redshift
    pkgs.acpi
    pkgs.inconsolata
    pkgs.dnsutils
    pkgs.skypeforlinux
    pkgs.spotify
    pkgs.okular
    (import "/etc/nixos/nixpkgs-mozilla/" {}).firefox-nightly-bin
  ];

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };

  programs.emacs = {
    enable = true;
    extraPackages = epkgs: [
      epkgs.nix-mode
      epkgs.magit
      epkgs.zerodark-theme
      pkgs.python36
      pkgs.python36Packages.jedi
      pkgs.python36Packages.epc
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
