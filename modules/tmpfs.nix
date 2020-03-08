{ config, lib, pkgs, ... }:

let
  cfg = config.my.tmpfs-root;

in {

  options.my.tmpfs-root.enable = lib.mkOption {
    default = config.fileSystems."/".fsType == "tmpfs";
    description = "Symlink persistent directories";
  };

  config = lib.mkIf cfg.enable {

    systemd.tmpfiles.rules = [
      "L /var/lib/bluetooth - - - - /nix/persistent/var/lib/bluetooth"
      "L /var/lib/NetworkManager - - - - /nix/persistent/var/lib/NetworkManager"
    ];

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
