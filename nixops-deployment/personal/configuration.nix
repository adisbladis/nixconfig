{ config, pkgs, ... }:

{
  imports = [
    ../../profiles/common.nix
    ./hardware-configuration.nix
  ];

  environment.systemPackages = let
    # Weechat + extra protocol support
    weechat-env = (pkgs.buildFHSUserEnv {
      name = "weechat";
      targetPkgs = (pkgs: [
        pkgs.weechat-matrix-bridge
        pkgs.weechat
      ]);
      runScript = "${pkgs.weechat}/bin/weechat";

      profile = ''
        export TERM=xterm
        mkdir -p $HOME/.weechat/lua/autoload
        cp ${pkgs.weechat-matrix-bridge}/share/matrix.lua $HOME/.weechat/lua/autoload/matrix.lua
      '';
    });
  in with pkgs; [
    weechat-env
    tmux
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  networking.interfaces.ens3.ipv4.addresses = [
    {
      address = "159.69.86.193";
      prefixLength = 32;
    }
  ];
  networking.defaultGateway = {
    address = "172.31.1.1";
    interface = "ens3";
  };
  networking.nameservers = [ "8.8.8.8" ];

  networking.hostName = "personal";
  services.openssh.enable = true;

  users.extraUsers.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCTrw8gZoBYkh4Ud8/QCXAaJk020XMbRlcu61QPTnpjvLLxAwSr3d+K7ccDal9FaSQg0GBx58aVRcdVoFBFmHbX6iqR6OT2hoenbxRfVa69DaY6w/eIY5seQ0Xzio8PsX2Cc4IPdM3XqlpTLhQ2+/kNnDC9/NYs2UX6r318uHrHPW5hs6rFPxvekcel56Vy1LKrMb5EgLwOFuhqegKpuZl6Dw39HHAIi0+cVCqc+eP8SmgdcYCm7CjLXU4mV8BwIMx/8TSDravJhnRLYX+S+BFUA3sXTeg1xzUKhFTE3lF4MJTNB613bcygX4HLXcG0YJ/6CDLBVey0xCfyKSbc18nlhRzuePzU8yYL8TRVoMJrEEurq8ZrkxX+lFs83CnFq4epH3vdz+Y6Q8foTVEF0XECgJ08MElXZRFRA5iWvO4S2PQLqn8LKRVxbF6NV34IrchCQavirZCv01FKRYfbpiNSzGLxKn2qvHDiYeqLV8gqj6wgO+DF8w6DsJcEUO3qiUDpbfXMCU8S5HgwVB7oOh+0g0Gq81HmjX0/a2WhuhbwC1Glt+gyLCLd/2RTRIetMymT8kZ61izVVNh0PeAoy4d2DpcKdmaK8CNjZ1/8c9a4Pxzg1HIHlPEyKf9NZ+TlGlUjmTEVOefxAWBVpQuwqEsOF1BkG9tDZsPQdcMhZbtvYQ== cardno:000605255225"
  ];

  system.stateVersion = "18.09"; # Did you read the comment?

}
