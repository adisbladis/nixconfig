{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.my.gaming;

in
{
  options.my.gaming.enable = mkEnableOption "Enables gaming related thingys.";

  config = mkIf cfg.enable {
    programs.steam.enable = true;
  };
}
