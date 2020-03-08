{ config, lib, pkgs, ... }:

{
  services.nixosManual.enable = false;
  services.openssh.enable = true;
  services.openssh.permitRootLogin = "no";
  services.openssh.passwordAuthentication = false;
  services.openssh.openFirewall = true;
  services.fail2ban.enable = true;
}
