{ config, lib, pkgs, ... }:

let
  cfg = config.my.voice;

in
{

  imports = [ ../../third_party/talon-nix/nixos ];

  options.my.voice.enable = lib.mkEnableOption "Enable common voice control options.";

  config = lib.mkIf cfg.enable {
    programs.talon.enable = true;
  };

}
