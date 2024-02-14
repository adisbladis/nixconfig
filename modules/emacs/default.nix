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

          copilot = eself.trivialBuild {
            pname = "emacs-copilot";
            version = "0.0.0";
            src = pkgs.fetchFromGitHub {
              owner = "jart";
              repo = "emacs-copilot";
              rev = "0cbf06cfd91cc8707a5c7d39b2b4358d8bea5d69";
              hash = "sha256-w+sK7F/TLdl+u+OcaXMR6FBQAKn0I9dCyhRxU+CihiI=";
            };
          };

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

      # Python
      pkgs.pyright
      pkgs.ruff
      pkgs.ruff-lsp

      # Nix LSP
      pkgs.nil
      pkgs.nixd

      pkgs.openscad-lsp
      pkgs.openscad

      pkgs.texlab
      pkgs.yaml-language-server
      pkgs.gopls
      pkgs.rust-analyzer
    ];
  };

}
