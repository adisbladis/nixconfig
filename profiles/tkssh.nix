{
  # To install packages in systemPackages
  nixpkgs.overlays = [
    (import ../overlays/nixpkgs-trustedkey/default.nix)
  ];

  # To use the provided services (tk-ssh-agent)
  imports = [
    ../overlays/nixpkgs-trustedkey/modules/default.nix
  ];

  services.tk-ssh-agent.enable = true;
}
