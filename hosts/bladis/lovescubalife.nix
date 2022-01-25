{ pkgs, lib, config, ... }:
{

  services.nginx = {
    enable = true;

    virtualHosts."www.lovescuba.life" = {
      locations = {
        "/".return = "302 https://lovescuba.life";
      };
    };

    virtualHosts."lovescuba.life" = {
      root = "/var/lib/www/lovescuba.life";
    };

  };


}
