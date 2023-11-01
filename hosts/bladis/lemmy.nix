{ pkgs, lib, config, ... }:

{
  services.lemmy = {
    enable = true;
    nginx.enable = true;
    database.createLocally = true;
    database.uri = "postgres:///lemmy?host=/run/postgresql&user=lemmy";
    settings.hostname = "lemmy.blad.is";
  };

  services.nginx.virtualHosts."lemmy.blad.is" = {
    enableACME = true;
    forceSSL = true;
  };
}
