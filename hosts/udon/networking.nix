{
  networking = {
    nameservers = [
      "8.8.4.4"
      "8.8.8.8"
    ];
    defaultGateway = "94.130.143.65";
    interfaces = {
      enp6s0 = {
        ip4 = [
          { address=""; prefixLength=26; }
        ];
      };
    };
  };

}

{
  networking.usePredictableInterfaceNames = false;
  networking.dhcpcd.enable = false;
  systemd.network = {
    enable = true;
    networks."eth0".extraConfig = ''
      [Match]
      Name = eth0
      [Network]
      # Add your own assigned ipv6 subnet here here!
      Address =  2a01:4f8:13b:2ceb::1/64
      Gateway = fe80::1
      # optionally you can do the same for ipv4 and disable DHCP ()
      Address =  94.130.143.84/26
      # Gateway = 94.130.143.65
    '';
  };
}
