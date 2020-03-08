{ config, lib, pkgs, ... }:

with lib;

let
  sshKeys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCTrw8gZoBYkh4Ud8/QCXAaJk020XMbRlcu61QPTnpjvLLxAwSr3d+K7ccDal9FaSQg0GBx58aVRcdVoFBFmHbX6iqR6OT2hoenbxRfVa69DaY6w/eIY5seQ0Xzio8PsX2Cc4IPdM3XqlpTLhQ2+/kNnDC9/NYs2UX6r318uHrHPW5hs6rFPxvekcel56Vy1LKrMb5EgLwOFuhqegKpuZl6Dw39HHAIi0+cVCqc+eP8SmgdcYCm7CjLXU4mV8BwIMx/8TSDravJhnRLYX+S+BFUA3sXTeg1xzUKhFTE3lF4MJTNB613bcygX4HLXcG0YJ/6CDLBVey0xCfyKSbc18nlhRzuePzU8yYL8TRVoMJrEEurq8ZrkxX+lFs83CnFq4epH3vdz+Y6Q8foTVEF0XECgJ08MElXZRFRA5iWvO4S2PQLqn8LKRVxbF6NV34IrchCQavirZCv01FKRYfbpiNSzGLxKn2qvHDiYeqLV8gqj6wgO+DF8w6DsJcEUO3qiUDpbfXMCU8S5HgwVB7oOh+0g0Gq81HmjX0/a2WhuhbwC1Glt+gyLCLd/2RTRIetMymT8kZ61izVVNh0PeAoy4d2DpcKdmaK8CNjZ1/8c9a4Pxzg1HIHlPEyKf9NZ+TlGlUjmTEVOefxAWBVpQuwqEsOF1BkG9tDZsPQdcMhZbtvYQ== cardno:000605255225"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCtr+rcxCZBAAqt8ocvhEEdBWfnRBCljjQPtC6Np24Y3H/HMe3rugsu3OhPscRV1k5hT+UlA2bpN8clMFAfK085orYY7DMUrgKQzFB7GDnOvuS1CqE1PRw7/OHLcWxDwf3YLpa8+ZIwMHFxR2gxsldCLGZV/VukNwhEvWs50SbXwVrjNkwA9LHy3Or0i6sAzU711V3B2heB83BnbT8lr3CKytF3uyoTEJvDE7XMmRdbvZK+c48bj6wDaqSmBEDrdNncsqnReDjScdNzXgP1849kMfIUwzXdhEF8QRVfU8n2A2kB0WRXiGgiL4ba5M+N9v1zLdzSHcmB0veWGgRyX8tN cardno:000607203159"
  ];
in {
  # imports = [ ./hardening.nix ];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  services.udev.extraRules = ''
    # set deadline scheduler for non-rotating disks
    # according to https://wiki.debian.org/SSDOptimization, deadline is preferred over noop
    ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="deadline"
  '';

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
    (import ../overlays/exwm-overlay)
  ];
  imports = [
    ../overlays/local/modules/default.nix
  ];

  time.timeZone = "Europe/London";

  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "dvorak";
  };

  programs.fish.enable = true;

  environment.systemPackages = with pkgs; [
    nox
    fish
    gnupg
    wget
    htop
    git
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

  services.openssh.enable = true;
  services.openssh.passwordAuthentication = false;

  users.extraUsers.root.openssh.authorizedKeys.keys = sshKeys;
  users.extraUsers.adisbladis = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "libvirtd"
      "docker"
    ];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = sshKeys;
    # For podman
    subUidRanges = [{ startUid = 100000; count = 65536; }];
    subGidRanges = [{ startGid = 100000; count = 65536; }];
  };
}
