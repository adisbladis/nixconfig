{ config, lib, pkgs, ... }:

let
  cfg = config.my.tmpfs-root;

in {

  options.my.tmpfs-root.enable = lib.mkEnableOption "Enables global settings required by tmpfs root.";

  config = lib.mkIf cfg.enable {

    home-manager.users.adisbladis = { ... }: {
      imports = [ ./home-manager/persistence.nix ];

      home.persistence."/nix/persistent/adisbladis" = {
        files = [];
        directories = [
          ".ssh"
          ".password-store"
          ".local/share/fish"
          ".mozilla/firefox"
          ".local/share/fish"
          ".local/share/direnv"
          ".emacs.d"
          "Downloads"
          "Music"
          "Documents"
          "Vids"
          "sauce"
          "Videos"
        ];
      };
    };

  };

}
