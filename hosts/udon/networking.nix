{ ... }: {
  # This file was populated at runtime with the networking
  # details gathered from the active system.
  networking = {
    nameservers = [
      "8.8.4.4"
      "8.8.8.8"
    ];
    defaultGateway = "139.59.112.1";
    defaultGateway6 = "";
    interfaces = {
      eth0 = {
        ip4 = [
          { address="139.59.123.119"; prefixLength=20; }
{ address="10.15.0.5"; prefixLength=16; }
        ];
        ip6 = [
          { address="fe80::7813:dfff:fee1:f06b"; prefixLength=64; }
        ];
      };

    };
  };
  services.udev.extraRules = ''
    ATTR{address}=="7a:13:df:e1:f0:6b", NAME="eth0"

  '';
}
