{

  network.description = "Personal machines";

  personal_server =
    { resources, ... }:
    {
      imports = [
        ./personal/configuration.nix
      ];

      deployment.targetHost = "159.69.86.193";
    };

  tablet =
    { resources, ... }:
    {
      imports = [
        ./tablet/configuration.nix
      ];

      deployment.targetHost = "192.168.0.61";
    };

  kombu =
    { resources, ... }:
    {
      imports = [
        ./kombu/configuration.nix
      ];
      deployment.targetHost = "192.168.0.70";
    };

  # laptop =
  #   { resources, ... }:
  #   {
  #     imports = [
  #       ../hosts/gari/configuration.nix
  #     ];

  #     deployment.targetHost = "127.0.0.1";
  #   };

}
