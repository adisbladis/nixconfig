{ pkgs, ... }:

{

  imports = [
    ./desktop.nix
    ./emacs.nix
  ];

  nixpkgs.overlays = [
    (import ../overlays/exwm-overlay)
  ];

  home.packages = with pkgs; let
    ipythonEnv = (python3.withPackages (ps: with ps; [
      ps.ipython
      ps.requests
      ps.psutil
    ]));
    # Link into ipythonEnv package to avoid polluting $PATH with python deps
    ipythonPackage = pkgs.runCommand "ipython-stripped" {} ''
      mkdir -p $out/bin
      ln -s ${ipythonEnv}/bin/ipython $out/bin/ipython
    '';
  in [
    ipythonPackage
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
