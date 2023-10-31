{ config, lib, pkgs, ... }:

let
  passwordHash = "$6$Uf8XtQxqVdMP.sKH$k7yRlrvuuwOb1gB1BPUJmVeAmGXd0EqlrcG3a7oMXLsoglmDrYF/nnzVLMB8TpN82Yg0jaZUMrkvCOpyYzMnn0";
  sshKeys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCtr+rcxCZBAAqt8ocvhEEdBWfnRBCljjQPtC6Np24Y3H/HMe3rugsu3OhPscRV1k5hT+UlA2bpN8clMFAfK085orYY7DMUrgKQzFB7GDnOvuS1CqE1PRw7/OHLcWxDwf3YLpa8+ZIwMHFxR2gxsldCLGZV/VukNwhEvWs50SbXwVrjNkwA9LHy3Or0i6sAzU711V3B2heB83BnbT8lr3CKytF3uyoTEJvDE7XMmRdbvZK+c48bj6wDaqSmBEDrdNncsqnReDjScdNzXgP1849kMfIUwzXdhEF8QRVfU8n2A2kB0WRXiGgiL4ba5M+N9v1zLdzSHcmB0veWGgRyX8tN cardno:000607203159"
  ];
in
{
  my.simpleserver.enable = true;

  boot.tmp.useTmpfs = true;

  users.extraUsers.root.openssh.authorizedKeys.keys = sshKeys;

  documentation.enable = true;

  systemd.coredump = {
    enable = true;
    extraConfig = "ExternalSizeMax=${toString (8 * 1024 * 1024 * 1024)}";
  };

  services.udev.extraRules = ''
    # set deadline scheduler for non-rotating disks
    # according to https://wiki.debian.org/SSDOptimization, deadline is preferred over noop
    ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="deadline"
  '';

  boot.kernelModules = [
    "i2c-dev" # Dasung monitor controls
  ];

  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "dvorak";
  };

  programs.fish.enable = true;

  environment.systemPackages = [
    pkgs.nix-top
    pkgs.dtach
    pkgs.fish
    pkgs.gnupg
    pkgs.wget
    pkgs.htop
    pkgs.gitAndTools.gitFull
    pkgs.tmux
    pkgs.jq
    pkgs.dnsutils
    pkgs.file
    pkgs.ripgrep
    pkgs.cryptsetup
  ];

  networking.firewall.enable = true;

  services.haveged.enable = true;

  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false;

  users.users.root.initialHashedPassword = passwordHash;
  users.users.adisbladis.initialHashedPassword = passwordHash;
  users.mutableUsers = false;

  networking.useDHCP = false;

  users.extraUsers.adisbladis = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" ];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = sshKeys;
  };

}
