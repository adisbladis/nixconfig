let
  pkgs = import <nixpkgs> {};
  pkg = pkgs.callPackage ./. { };
  inherit (pkg.passthru) pythonEnv;

in pkgs.mkShell {
  packages = [
    pythonEnv
  ];
}
