{ config, pkgs, lib, ... }:

{
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowBroken = true;

  nix = {
    # daemonCPUSchedPolicy = "idle";
    # daemonIOSchedClass = "idle";
    # daemonIOSchedPriority = 5;
    binaryCaches = [
      "https://nix-community.cachix.org"
    ];
    binaryCachePublicKeys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    nixPath = [
      "nixpkgs=${lib.cleanSource pkgs.path}"
    ];
    autoOptimiseStore = true;
    useSandbox = true;
    trustedUsers = [ "@wheel" ];

    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
      experimental-features = nix-command flakes
    '';
  };

}
