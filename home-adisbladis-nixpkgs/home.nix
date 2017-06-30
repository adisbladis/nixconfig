{ pkgs, ... }:

{

  home.packages = [
    pkgs.gimp
    pkgs.kdeconnect
    pkgs.youtube-dl
    pkgs.pavucontrol
    pkgs.browserpass
    pkgs.pass
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
      pkgs.python36
      pkgs.python36Packages.jedi
      pkgs.python36Packages.epc
    ];
  };

  programs.git = {
    enable = true;
    userName = "adisbladis";
    userEmail = "adis@blad.is";
    signing.key = "FA75289B489AE1A51BCA18ABED58F95069B004F5";
    signing.signByDefault = true;
  };

  programs.firefox.enable = true;

  manual.manpages.enable = false;
}
