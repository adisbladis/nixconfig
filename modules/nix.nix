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
    binaryCaches = [
      "https://nix-community.cachix.org"
    ];
    binaryCachePublicKeys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    nixPath =
      let
        overlays = pkgs.writeText "overlays.nix" ''
          [ (import ${builtins.fetchGit ../third_party/emacs-overlay}) ]
        '';
      in
      [
        "nixpkgs=${builtins.fetchGit pkgs.path}"
        "nixpkgs-overlays=${overlays}"
      ];
    autoOptimiseStore = true;
    useSandbox = true;
    trustedUsers = [ "@wheel" ];

    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
    '';
  };

}
