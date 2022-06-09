{ lib ? pkgs.lib
, pkgs ? import <nixpkgs> { }
}:

let
  craneLib = import ../third_party/crane { inherit pkgs; };

  src = lib.cleanSource ./.;

  cargoArtifacts = craneLib.buildDepsOnly {
    inherit src;
  };

in craneLib.buildPackage {
  inherit cargoArtifacts src;
  buildInputs = [
    pkgs.libnotify
  ];
}
