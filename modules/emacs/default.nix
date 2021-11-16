{ config, pkgs, lib, ... }:

let
  pkg = pkgs.callPackage
    (
      { emacsWithPackagesFromUsePackage }:
      (emacsWithPackagesFromUsePackage {
        # package = pkgs.emacsGcc;
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
    ];
  };

}
