{ lib ? pkgs.lib
, pkgs ? import <nixpkgs> { }
}:

let
  src = lib.cleanSource ./.;

  cargoArtifacts = pkgs.craneLib.buildDepsOnly {
    inherit src;
  };

in pkgs.craneLib.buildPackage {
  inherit cargoArtifacts src;
  buildInputs = [
    pkgs.libnotify
  ];
}
