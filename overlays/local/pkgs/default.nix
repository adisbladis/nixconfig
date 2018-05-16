self: super:

with super.lib;
let
  kernelPatches = super.kernelPatches;

in rec {
  simpleserver = super.callPackage ./simpleserver.nix { };

  linux_4_15 = super.callPackage ./linux-4.15.nix {
    kernelPatches =
      [ kernelPatches.bridge_stp_helper
        # See pkgs/os-specific/linux/kernel/cpu-cgroup-v2-patches/README.md
        # when adding a new linux version
        # kernelPatches.cpu-cgroup-v2."4.11"
        kernelPatches.modinst_arg_list_too_long
      ]
      ++ optionals ((super.platform.kernelArch or null) == "mips")
      [ kernelPatches.mips_fpureg_emu
        kernelPatches.mips_fpu_sigill
        kernelPatches.mips_ext3_n32
      ];
  };

  linuxPackages_4_15 = super.recurseIntoAttrs (super.linuxPackagesFor linux_4_15);

}
