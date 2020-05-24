{ lib, ... }:

{
  nixpkgs.overlays = [
    (import ../overlays/local/pkgs/default.nix)
    (import ../overlays/exwm-overlay)
  ];

  imports = [
    ../home-adisbladis-nixpkgs/home-manager/nixos
    ../overlays/local/modules/default.nix
    ./common.nix
    ./graphical-desktop.nix
    ./my-gaming.nix
    ./my-laptop.nix
    ./my-spell.nix
    ./podman.nix
    ./tmpfs.nix
    ./persistence.nix
  ];

}
