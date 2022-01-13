# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/profiles/qemu-guest.nix")
    ];

  boot.initrd.availableKernelModules = [ "ata_piix" "virtio_pci" "xhci_pci" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "none";
      fsType = "tmpfs";
      options = [ "defaults" "size=8G" "mode=755" ];
    };

  fileSystems."/nix" =
    { device = "rpool/nix";
      fsType = "zfs";
    };

  fileSystems."/var/lib" =
    { device = "rpool/var/lib";
      fsType = "zfs";
    };

  fileSystems."/var/log" =
    { device = "rpool/var/log";
      fsType = "zfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/a39d4490-4969-4247-a533-9d1b0d490735";
      fsType = "btrfs";
    };

  fileSystems."/etc/nixos" =
    { device = "rpool/etc/nixos";
      fsType = "zfs";
    };

  fileSystems."/etc/ssh" =
    { device = "rpool/etc/ssh";
      fsType = "zfs";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/a8e933e7-2e3d-4db7-8c3c-7ca1b9c85235"; }
    ];

}
