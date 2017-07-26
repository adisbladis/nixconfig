{ config, lib, pkgs, ... }:

with lib;

{
  services.openssh.enable = true
  services.openssh.permitRootLogin = "no";
  services.openssh.passwordAuthentication = false;
  services.fail2ban.enable = true;
}
