{ config, lib, pkgs, ... }:

let
  cfg = config.my.sound;

in
{

  options.my.sound.enable = lib.mkEnableOption "Enables common sound settings.";

  config = lib.mkIf cfg.enable {

    environment.systemPackages = [
      pkgs.pamixer
    ];

    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };

}
