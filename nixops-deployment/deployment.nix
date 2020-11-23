let

  deployment = {
    provisionSSHKey = false;
  };

in {

  network.description = "Personal machines";

  personal_server =
    { resources, ... }:
    {
      imports = [
        ./personal/configuration.nix
      ];

      deployment = deployment // {
        targetHost = "159.69.86.193";
      };
    };

  tablet =
    { resources, ... }:
    {
      imports = [
        ./tablet/configuration.nix
      ];

      deployment = deployment // {
        targetHost = "192.168.0.61";
      };
    };

  kombu =
    { resources, ... }:
    {
      imports = [
        ./kombu/configuration.nix
      ];
      deployment = deployment // {
        targetHost = "192.168.0.70";
      };
    };

  inari =
    { resources, ... }:
    {
      imports = [
        ../hosts/inari/configuration.nix
      ];
      deployment = deployment // {
        hasFastConnection = true;
        targetHost = "192.168.1.149";
      };
    };

  laptop =
    { resources, ... }:
    {
      imports = [
        ../hosts/gari/configuration.nix
      ];

      deployment = deployment // {
        targetHost = "127.0.0.1";
      };
    };

}
