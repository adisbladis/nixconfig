{ config, lib, pkgs, ... }:

let
  cfg = config.my.gaming;

in
{
  options.my.gaming.enable = lib.mkEnableOption "Enables gaming related thingys.";

  config = lib.mkIf cfg.enable {

    nixpkgs.overlays = [
      (self: super: {

        steam = super.steam.override {
          extraPkgs = pkgs: [
            pkgs.xdg-user-dirs
            pkgs.networkmanager
          ];
        };

      })
    ];

    # Support 32bit audio things
    services.pipewire.alsa.support32Bit = true;

    programs.steam.enable = true;

  };
}
