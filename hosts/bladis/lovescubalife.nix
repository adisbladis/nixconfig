{ pkgs, lib, config, ... }:
{

  services.nginx = {
    enable = true;

    virtualHosts."www.lovescuba.life" = {
      enableACME = true;
      forceSSL = true;
      locations = {
        "/".return = "302 https://instagram.com/lovescubalife";
      };
    };

    virtualHosts."lovescuba.life" = {
      enableACME = true;
      forceSSL = true;
      locations = {
        "/".return = "302 https://instagram.com/lovescubalife";
      };
    };

  };


}
