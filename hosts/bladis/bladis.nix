{ pkgs, lib, config, ... }:
{

  services.nginx = {
    enable = true;
    virtualHosts."files.blad.is" = {
      enableACME = true;
      forceSSL = true;
      root = "/var/lib/www/files.blad.is";
    };
  };


}
