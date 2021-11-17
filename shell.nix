let
  pkgs = import ./third_party/nixpkgs {
    overlays = [
      (import ./third_party/emacs-overlay)
    ];
  };
  inherit (pkgs) lib;

  nixPath = lib.concatStringsSep ":" (lib.mapAttrsToList (n: v: "${n}=${v}") {
    nixpkgs = toString ./third_party/nixpkgs;
    nixos-config = lib.concatStringsSep "/" [
      (toString ./hosts)
      "$(${pkgs.nettools}/bin/hostname -s)"
      "configuration.nix"
    ];
  });

in
pkgs.mkShell {

  packages = [
    # Use nixos-rebuild switch --use-remote-sudo
    pkgs.nixos-rebuild
  ];

  shellHook = ''
    export NIX_PATH=${nixPath}
  '';

}
