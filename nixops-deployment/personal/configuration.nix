{ config, pkgs, ... }:

{
  imports = [
    ../../modules
    ./hardware-configuration.nix
  ];

  my.common-cli.enable = true;

  users.extraUsers.adisbladis.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC9Cy5XfsjN8Wp60fTjWbKZe7mYpbALiSNdjfHod6rbg0oqicckRhzZApXY8RsoH89u95F2FUzKphjbveAuRk25fyFWXIXwIalmz4VGPisug9+wImcOnBJT7HVMPlY4sS80ZkphJXTbNLjsGBg5vOf0qM7csM0cAkRzVii74gP1moaFwYd0elE+hZhtnD70xLeo7LfBPkIkMJss2zzUEYN45llJEcGB7ZavI8VoBS7P35D/Ma5L2T2F6/dT3Nw21B0zYf3xLBtMtGTUxEO0in4HUIO+qfzOeejQckbYPLMAVUPNRDXPrp4fOhKyc57kL6XFIpsm14I0oFFZlKAV6RD1 weechat-android"
  ];

  # environment.systemPackages = let
  #   weechatPackage = pkgs.weechat.override {
  #     configure = { availablePlugins, ... }: {
  #       scripts = with pkgs.weechatScripts; [
  #         weechat-xmpp weechat-matrix-bridge wee-slack
  #       ];
  #     };
  #   };

  #   # Weechat + extra protocol support
  #   weechat-env = (pkgs.buildFHSUserEnv {
  #     name = "weechat";
  #     targetPkgs = (pkgs: [ weechatPackage ]);
  #     runScript = "${weechatPackage}/bin/weechat";

  #     profile = ''
  #       export TERM=xterm
  #       mkdir -p $HOME/.weechat/lua/autoload
  #     '';
  #   });
  # in with pkgs; [
  #   weechat-env
  #   tmux
  # ];

  environment.systemPackages = [ pkgs.tmux ];

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
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCtr+rcxCZBAAqt8ocvhEEdBWfnRBCljjQPtC6Np24Y3H/HMe3rugsu3OhPscRV1k5hT+UlA2bpN8clMFAfK085orYY7DMUrgKQzFB7GDnOvuS1CqE1PRw7/OHLcWxDwf3YLpa8+ZIwMHFxR2gxsldCLGZV/VukNwhEvWs50SbXwVrjNkwA9LHy3Or0i6sAzU711V3B2heB83BnbT8lr3CKytF3uyoTEJvDE7XMmRdbvZK+c48bj6wDaqSmBEDrdNncsqnReDjScdNzXgP1849kMfIUwzXdhEF8QRVfU8n2A2kB0WRXiGgiL4ba5M+N9v1zLdzSHcmB0veWGgRyX8tN cardno:000607203159"
  ];

  system.stateVersion = "18.09"; # Did you read the comment?

}
