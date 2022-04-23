{ config, pkgs, lib, ... }:

let
  pkg = pkgs.callPackage
    (
      { emacsWithPackagesFromUsePackage }:
      (emacsWithPackagesFromUsePackage {
        package = pkgs.emacsNativeComp;
        config = ./emacs.el;
        alwaysEnsure = true;
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
      pkgs.rnix-lsp
      pkgs.gopls
      pkgs.rust-analyzer
    ];
  };

}
