{ config, pkgs, lib, ... }:

let
  pkg = pkgs.callPackage
    (
      { emacsWithPackagesFromUsePackage }:
      (emacsWithPackagesFromUsePackage {
        package = pkgs.emacs-unstable;
        config = ./emacs.el;
        alwaysEnsure = true;

        override = eself: esuper: {
          exwm = esuper.elpaDevelPackages.exwm;
        };

      })
    )
    { };

  cfg = config.my.emacs;

in
{

  options.my.emacs.enable = lib.mkEnableOption "Enable Emacs.";

  config = lib.mkIf cfg.enable {

    home-manager.users.adisbladis = { ... }: {
      home.file.".emacs".source = ./emacs.el;
    };

    environment.systemPackages = [
      pkg

      pkgs.nixpkgs-fmt

      # Provides:
      # vscode-html-language-server
      # vscode-css-language-server
      # vscode-json-language-server
      # vscode-eslint-language-server
      pkgs.nodePackages.vscode-langservers-extracted

      pkgs.ccls
      pkgs.nodePackages.bash-language-server
      pkgs.nodePackages.typescript pkgs.nodePackages.typescript-language-server
      pkgs.pyright
      pkgs.nil  # Nix LSP
      pkgs.gopls
      pkgs.rust-analyzer
    ];
  };

}
