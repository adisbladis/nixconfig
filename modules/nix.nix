{ config, pkgs, lib, ... }:

let
  package = pkgs.nix_2_3;
in {
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowBroken = true;

  nixpkgs.overlays = [
    (import ../third_party/emacs-overlay)
  ];

  environment.systemPackages = [
    pkgs.nix-eval-jobs
  ];

  nix = {
    package = package;
    # daemonCPUSchedPolicy = "idle";
    # daemonIOSchedClass = "idle";
    # daemonIOSchedPriority = 5;
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
    '';
  };

}
