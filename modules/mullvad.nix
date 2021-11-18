{ config, lib, pkgs, ... }:

let
  cfg = config.my.mullvad;

in
{

  options.my.mullvad.enable = lib.mkEnableOption "Enables common Mullvad VPN settings.";

  config = lib.mkIf cfg.enable {
    services.mullvad-vpn.enable = true;
    environment.systemPackages = [ pkgs.mullvad-vpn ];
  };

}
