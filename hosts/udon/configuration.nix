{ ... }: {
  imports = [
    ./hardware-configuration.nix
    ./networking.nix # generated at runtime by nixos-infect
    ../../profiles/common.nix
    ../../profiles/server.nix
  ];

  boot.cleanTmpDir = true;
  networking.hostName = "udon";
  networking.firewall.allowPing = true;
}
