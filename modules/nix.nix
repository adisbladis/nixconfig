{ config, pkgs, lib, ... }:

let
  package = pkgs.nix;
in {
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowBroken = true;

  nixpkgs.overlays = [
    (import ../third_party/emacs-overlay)
    (self: super: {
      craneLib = import ../third_party/crane { pkgs = self; };
    })
  ];

  nix = {
    package = package;
    daemonCPUSchedPolicy = "idle";
    daemonIOSchedClass = "idle";
    daemonIOSchedPriority = 5;
    settings.substituters = [
      "https://nix-community.cachix.org"
    ];
    settings.trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    nixPath =[ "nixpkgs=${pkgs.path}" ];
    settings.auto-optimise-store = true;
    settings.sandbox = true;
    settings.trusted-users = [ "@wheel" ];

    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
      experimental-features = nix-command flakes
    '';
  };

}
