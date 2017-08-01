{ config, lib, pkgs, ... }:

with lib;

{
  imports = [ ./hardening.nix ];
  services.nixosManual.enable = false;                                                                                                                                                                            
  services.openssh.enable = true;                                                                                                                                                                                 
  services.openssh.permitRootLogin = "no";                                                                                                                                                                        
  services.openssh.passwordAuthentication = false;                                                                                                                                                                
  services.fail2ban.enable = true;                                                                                                                                                                                
  programs.mosh.enable = true;
}
