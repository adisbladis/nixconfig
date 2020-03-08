{ config, lib, pkgs, ... }:

let
  sshKeys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCTrw8gZoBYkh4Ud8/QCXAaJk020XMbRlcu61QPTnpjvLLxAwSr3d+K7ccDal9FaSQg0GBx58aVRcdVoFBFmHbX6iqR6OT2hoenbxRfVa69DaY6w/eIY5seQ0Xzio8PsX2Cc4IPdM3XqlpTLhQ2+/kNnDC9/NYs2UX6r318uHrHPW5hs6rFPxvekcel56Vy1LKrMb5EgLwOFuhqegKpuZl6Dw39HHAIi0+cVCqc+eP8SmgdcYCm7CjLXU4mV8BwIMx/8TSDravJhnRLYX+S+BFUA3sXTeg1xzUKhFTE3lF4MJTNB613bcygX4HLXcG0YJ/6CDLBVey0xCfyKSbc18nlhRzuePzU8yYL8TRVoMJrEEurq8ZrkxX+lFs83CnFq4epH3vdz+Y6Q8foTVEF0XECgJ08MElXZRFRA5iWvO4S2PQLqn8LKRVxbF6NV34IrchCQavirZCv01FKRYfbpiNSzGLxKn2qvHDiYeqLV8gqj6wgO+DF8w6DsJcEUO3qiUDpbfXMCU8S5HgwVB7oOh+0g0Gq81HmjX0/a2WhuhbwC1Glt+gyLCLd/2RTRIetMymT8kZ61izVVNh0PeAoy4d2DpcKdmaK8CNjZ1/8c9a4Pxzg1HIHlPEyKf9NZ+TlGlUjmTEVOefxAWBVpQuwqEsOF1BkG9tDZsPQdcMhZbtvYQ== cardno:000605255225"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCtr+rcxCZBAAqt8ocvhEEdBWfnRBCljjQPtC6Np24Y3H/HMe3rugsu3OhPscRV1k5hT+UlA2bpN8clMFAfK085orYY7DMUrgKQzFB7GDnOvuS1CqE1PRw7/OHLcWxDwf3YLpa8+ZIwMHFxR2gxsldCLGZV/VukNwhEvWs50SbXwVrjNkwA9LHy3Or0i6sAzU711V3B2heB83BnbT8lr3CKytF3uyoTEJvDE7XMmRdbvZK+c48bj6wDaqSmBEDrdNncsqnReDjScdNzXgP1849kMfIUwzXdhEF8QRVfU8n2A2kB0WRXiGgiL4ba5M+N9v1zLdzSHcmB0veWGgRyX8tN cardno:000607203159"
  ];

  secrets = import ../secrets.nix;

  cfg = config.my.common-cli;

in {

  options.my.common-cli.enable = lib.mkEnableOption "Enables my common CLI thingies.";

  config = lib.mkIf cfg.enable {

    services.lorri.enable = true;

    documentation.enable = false;

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
    nix.autoOptimiseStore = true;
    nix.useSandbox = true;

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
      dnsutils
      file
      ag
      ripgrep
    ];

    networking.firewall.enable = true;

    services.haveged.enable = true;

    services.openssh.enable = true;
    services.openssh.passwordAuthentication = false;

    users.users.root.initialHashedPassword = secrets.passwordHash;
    users.users.adisbladis.initialHashedPassword = secrets.passwordHash;
    users.mutableUsers = false;

    users.extraUsers.root.openssh.authorizedKeys.keys = sshKeys;
    users.extraUsers.adisbladis = {
      isNormalUser = true;
      uid = 1000;
      extraGroups = [ "wheel" ];
      shell = pkgs.fish;
      openssh.authorizedKeys.keys = sshKeys;
    };

    home-manager.users.adisbladis = {...}: {

      nixpkgs.overlays = [
        (import ../overlays/exwm-overlay)
      ];

      home.packages = with pkgs; let
        ipythonEnv = (python3.withPackages (ps: [
          ps.ipython
          ps.requests
          ps.psutil
          ps.nixpkgs
        ]));
        # Link into ipythonEnv package to avoid polluting $PATH with python deps
        ipythonPackage = pkgs.runCommand "ipython-stripped" {} ''
          mkdir -p $out/bin
          ln -s ${ipythonEnv}/bin/ipython $out/bin/ipython
        '';
      in [
        ipythonPackage
        nix-review
        traceroute
        ripgrep
        ag
        whois
        nmap
        unzip
        zip
        (pkgs.callPackage ../home-adisbladis-nixpkgs/emacs {})
      ];

      # Fish config
      home.file.".config/fish/functions/fish_prompt.fish".source = ../home-adisbladis-nixpkgs/dotfiles/fish/functions/fish_prompt.fish;

      home.sessionVariables.LESS = "-R";

      programs.direnv.enable = true;
      home.file.".direnvrc".text = ''
        use_nix() {
          eval "$(lorri direnv)"
        }
      '';

      programs.fish = {
        enable = true;
        shellAliases = with pkgs; {
          pcat = "${python3Packages.pygments}/bin/pygmentize";
        };
      };

      programs.git = {
        enable = true;
        userName = "adisbladis";
        userEmail = "adisbladis@gmail.com";
        signing.key = "00244EF5295026AA323A4BDB110BFAD44C6249B7";
      };

      manual.manpages.enable = false;


    };

  };

}
