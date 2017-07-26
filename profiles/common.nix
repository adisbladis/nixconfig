{ config, lib, pkgs, ... }:

with lib;

{
  imports = [ ../nixpkgs/nixos/modules/profiles/hardened.nix ];

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "17.09";

  # Use local nixpkgs checkout
  nix.nixPath = [
    "/etc/nixos"
    "nixos-config=/etc/nixos/configuration.nix"
  ];

  nix.useSandbox = true;

  # KSPP kernel
  boot.kernelPackages = pkgs.linuxPackages_hardened_copperhead;
  security.lockKernelModules = false;  # No wifi with this one enabled
  # The hardened profile is too strict with user namespaces
  # These are needed for firejail and other containment tools
  boot.kernel.sysctl."user.max_user_namespaces" = 46806;

  time.timeZone = "Asia/Hong_Kong";

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "dvorak-sv-a1";
    defaultLocale = "en_US.UTF-8";
  };

  environment.systemPackages = with pkgs; [
    fish
    gnupg
    emacs
    wget
    htop
    mosh
    git
    screen
    tmux
    jq
    sshfs-fuse
    dnsutils
  ];

  networking.firewall.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.adisbladis = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.fish;
  };
}
