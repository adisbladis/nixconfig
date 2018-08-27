{ pkgs, ... }:

{

  imports = [
    ./desktop.nix
    ./emacs.nix
  ];

  nixpkgs.overlays = [
    (import /etc/nixos/overlays/local/pkgs)
  ];

  home.packages = with pkgs; [
    home-manager.home-manager
    wgetpaste
    nix-review
    traceroute
    ripgrep
    ag
    whois
    nmap
    unzip
    zip
  ];

  # Fish config
  home.file.".config/fish/functions/fish_prompt.fish".source = ./dotfiles/fish/functions/fish_prompt.fish;
  home.file.".config/fish/functions/fish_right_prompt.fish".source = ./dotfiles/fish/functions/fish_right_prompt.fish;

  home.sessionVariables.LESS = "-R";

  programs.direnv.enable = true;

  programs.fish = {
    enable = true;
    shellAliases = with pkgs; {
      pcat = "${python3Packages.pygments}/bin/pygmentize";
      ipython = let
        pythonEnv = (python3.withPackages (ps: [
          ps.ipython
          ps.requests
          ps.psutil
        ]));
      in "${pythonEnv}/bin/ipython";
    };
  };

  programs.git = {
    enable = true;
    userName = "adisbladis";
    userEmail = "adisbladis@gmail.com";
    signing.key = "FA75289B489AE1A51BCA18ABED58F95069B004F5";
  };

  manual.manpages.enable = true;
}
