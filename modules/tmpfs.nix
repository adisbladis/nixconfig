{ config, lib, pkgs, ... }:

let
  cfg = config.my.tmpfs-root;

in {

  options.my.tmpfs-root.enable = lib.mkOption {
    default = config.fileSystems."/".fsType == "tmpfs";
    description = "Symlink persistent directories";
  };

  config = lib.mkIf cfg.enable {

    # systemd.tmpfiles.rules = [
    #   "L /var/lib/bluetooth - - - - /nix/persistent/var/lib/bluetooth"
    #   "L /var/lib/NetworkManager - - - - /nix/persistent/var/lib/NetworkManager"
    # ];

    environment.persistence = {
      targetDir = "/nix/persistent";
      # root = {
      #   directories = [
      #     "/var/log"
      #     "/var/lib/bluetooth"
      #   ];
      # };
      etc = {
        directories = [
          "nixos"
          "NetworkManager/system-connections"
        ];
        files = [ "machine-id" ];
      };
    };

    home-manager.users.adisbladis = { ... }: {
      imports = [ ./home-manager/persistence.nix ];

      home.persistence."/nix/persistent/adisbladis" = {
        files = [
          # ".gnupg/pubring.kbx"
          # ".gnupg/trustdb.gpg"
          ".gnupg/random_seed"
        ];
        directories = [
          ".ssh"
          ".password-store"
          ".mozilla/firefox"
          ".local/share/fish"
          ".local/share/direnv"
          ".local/share/containers"
          ".emacs.d"
          "Downloads"
          "Music"
          "Documents"
          "go"
          "Vids"
          "sauce"
          "Videos"
          "Pictures"
          ".local/share/fish"
        ];
      };
    };

  };

}
