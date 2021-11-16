let
  pkgs = import ./third_party/nixpkgs {
    overlays = [
      (import ./third_party/emacs-overlay)
    ];
  };
  inherit (pkgs) lib;
  inherit (builtins) toString;

in
pkgs.mkShell {

  packages = [
    pkgs.nixos-rebuild
  ];

  NIX_PATH = lib.concatStringsSep ":" (lib.mapAttrsToList (n: v: "${n}=${v}") {
    nixpkgs = "${toString ./third_party/nixpkgs}";
    nixos-config = "${toString ./configuration.nix}";
  });

}
