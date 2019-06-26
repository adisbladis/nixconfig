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

  # laptop =
  #   { resources, ... }:
  #   {
  #     imports = [
  #       ../hosts/gari/configuration.nix
  #     ];

  #     deployment.targetHost = "127.0.0.1";
  #   };

}
