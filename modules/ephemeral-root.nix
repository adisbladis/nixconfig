{ config, lib, pkgs, ... }:
let
  cfg = config.my.ephemeral-root;

in
{
  options.my.ephemeral-root.enable = lib.mkEnableOption "Enables common ephemeral root persistent mappings.";

  imports = [
    ../third_party/impermanence/nixos.nix
  ];

  config = lib.mkIf cfg.enable {

    fileSystems."/persistent".neededForBoot = true;

    programs.fuse.userAllowOther = true;

    environment.persistence."/persistent" = {
      directories = [
        "/var/log"
        "/var/lib/bluetooth"
        "/var/lib/systemd/coredump"
        "/etc/NetworkManager/system-connections"
      ];
      files = [
        "/etc/machine-id"
        "/etc/ssh/ssh_host_ed25519_key"
        "/etc/ssh/ssh_host_ed25519_key.pub"
        "/etc/ssh/ssh_host_rsa_key"
        "/etc/ssh/ssh_host_rsa_key.pub"
      ];
    };

    home-manager.users.adisbladis = { lib, ... }:
      {
        imports = [ ../third_party/impermanence/home-manager.nix ];

        home.persistence."/persistent/home/adisbladis" = {
          allowOther = true;
          files = [ ];
          directories = [
            "Downloads"
            "Music"
            "Documents"
            "go"
            "Vids"
            "sauce"
            "Videos"
            "Pictures"
            ".gnupg"
            ".mozilla"
            ".ssh"
            ".emacs.d"
            ".aws"
            ".local/share/containers"
            ".local/share/fish"
            ".local/share/keyrings"
            ".local/share/direnv"
            ".cache/lorri"
            ".cache/nix"
            ".local/share/pantalaimon"
            ".password-store"
            ".config/kdeconnect"
            ".config/pipewire/media-session.d"
            ".config/spotify"
            ".cache/spotify"

            ".steam"
            ".local/share/Steam"

          ];
        };
      };

  };
}
