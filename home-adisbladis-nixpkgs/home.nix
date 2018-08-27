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
  home.file.".config/fish/functions/ipython.fish".source = ./dotfiles/fish/functions/ipython.fish;
  home.file.".config/fish/functions/pcat.fish".source = ./dotfiles/fish/functions/pcat.fish;
  home.file.".config/fish/functions/pless.fish".source = ./dotfiles/fish/functions/pless.fish;
  home.file.".config/fish/functions/wgetpaste.fish".source = ./dotfiles/fish/functions/wgetpaste.fish;
  home.file.".config/fish/config.fish".source = ./dotfiles/fish/config.fish;

  home.sessionVariables.LESS = "-R";

  programs.git = {
    enable = true;
    userName = "adisbladis";
    userEmail = "adisbladis@gmail.com";
    signing.key = "FA75289B489AE1A51BCA18ABED58F95069B004F5";
  };

  manual.manpages.enable = true;
}
