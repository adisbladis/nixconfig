{ config, lib, pkgs, ... }:

with lib;

{
  # imports = [ ./hardening.nix ];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Use local nixpkgs checkout
  nix.nixPath = [
    "/etc/nixos"
    "nixos-config=/etc/nixos/configuration.nix"
  ];
  # nix.package = pkgs.nixUnstable;
  nix.autoOptimiseStore = true;
  nix.useSandbox = true;

  # Local overlays
  nixpkgs.overlays = [
    (import ../overlays/local/pkgs/default.nix)
  ];
  imports = [
    ../overlays/local/modules/default.nix
  ];

  time.timeZone = "Asia/Hong_Kong";

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "dvorak-sv-a1";
    defaultLocale = "en_US.UTF-8";
  };

  programs.fish.enable = true;

  environment.systemPackages = with pkgs; [
    nox
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
    file
    ag
    ripgrep
  ];

  networking.firewall.enable = true;

  services.haveged.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.adisbladis = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "networkmanager" "video" ];
    shell = pkgs.fish;

    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCTrw8gZoBYkh4Ud8/QCXAaJk020XMbRlcu61QPTnpjvLLxAwSr3d+K7ccDal9FaSQg0GBx58aVRcdVoFBFmHbX6iqR6OT2hoenbxRfVa69DaY6w/eIY5seQ0Xzio8PsX2Cc4IPdM3XqlpTLhQ2+/kNnDC9/NYs2UX6r318uHrHPW5hs6rFPxvekcel56Vy1LKrMb5EgLwOFuhqegKpuZl6Dw39HHAIi0+cVCqc+eP8SmgdcYCm7CjLXU4mV8BwIMx/8TSDravJhnRLYX+S+BFUA3sXTeg1xzUKhFTE3lF4MJTNB613bcygX4HLXcG0YJ/6CDLBVey0xCfyKSbc18nlhRzuePzU8yYL8TRVoMJrEEurq8ZrkxX+lFs83CnFq4epH3vdz+Y6Q8foTVEF0XECgJ08MElXZRFRA5iWvO4S2PQLqn8LKRVxbF6NV34IrchCQavirZCv01FKRYfbpiNSzGLxKn2qvHDiYeqLV8gqj6wgO+DF8w6DsJcEUO3qiUDpbfXMCU8S5HgwVB7oOh+0g0Gq81HmjX0/a2WhuhbwC1Glt+gyLCLd/2RTRIetMymT8kZ61izVVNh0PeAoy4d2DpcKdmaK8CNjZ1/8c9a4Pxzg1HIHlPEyKf9NZ+TlGlUjmTEVOefxAWBVpQuwqEsOF1BkG9tDZsPQdcMhZbtvYQ== cardno:000605255225"
    ];
  };
}
