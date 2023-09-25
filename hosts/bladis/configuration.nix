{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./synapse.nix
    ./bladis.nix
    ./lovescubalife.nix
    ./lemmy.nix
  ];

  environment.systemPackages = [
    pkgs.casync
  ];

  security.acme.acceptTerms = true;
  security.acme.defaults.email = "adisbladis@gmail.com";

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  services.openssh.enable = true;

  boot.kernelParams = [ "net.ifnames=0" ];

  services.fail2ban.enable = true;

  networking.firewall.allowedTCPPorts = [
    22
    80
    443
  ];

  networking = {
    hostId = "28b26374";
    defaultGateway = {
      address = "172.31.1.1";
      interface = "eth0";
    };
    nameservers = [ "8.8.8.8" ];
    interfaces.eth0 = {
      ipv4.addresses = [{
        address = "78.47.19.28";
        prefixLength = 32;
      }];
      useDHCP = false;
    };
  };

  users.users.root.initialHashedPassword = "$6$Uf8XtQxqVdMP.sKH$k7yRlrvuuwOb1gB1BPUJmVeAmGXd0EqlrcG3a7oMXLsoglmDrYF/nnzVLMB8TpN82Yg0jaZUMrkvCOpyYzMnn0";

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCtr+rcxCZBAAqt8ocvhEEdBWfnRBCljjQPtC6Np24Y3H/HMe3rugsu3OhPscRV1k5hT+UlA2bpN8clMFAfK085orYY7DMUrgKQzFB7GDnOvuS1CqE1PRw7/OHLcWxDwf3YLpa8+ZIwMHFxR2gxsldCLGZV/VukNwhEvWs50SbXwVrjNkwA9LHy3Or0i6sAzU711V3B2heB83BnbT8lr3CKytF3uyoTEJvDE7XMmRdbvZK+c48bj6wDaqSmBEDrdNncsqnReDjScdNzXgP1849kMfIUwzXdhEF8QRVfU8n2A2kB0WRXiGgiL4ba5M+N9v1zLdzSHcmB0veWGgRyX8tN"
  ];

  boot.kernelPackages = pkgs.zfs.latestCompatibleLinuxPackages;

  system.stateVersion = "21.05";

}
