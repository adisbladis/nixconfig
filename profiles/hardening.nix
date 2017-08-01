{ config, lib, pkgs, ... }:

with lib;

{
  imports = [ ../nixpkgs/nixos/modules/profiles/hardened.nix ];
  
  # KSPP kernel
  boot.kernelPackages = pkgs.linuxPackages_hardened_copperhead;

  # The hardened profile is too strict with user namespaces
  # These are needed for firejail and other containment tools
  boot.kernel.sysctl."user.max_user_namespaces" = 46806;
}
