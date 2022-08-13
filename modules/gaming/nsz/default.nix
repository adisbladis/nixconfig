{ pkgs ? import <nixpkgs> { } }:

(pkgs.poetry2nix.mkPoetryPackages {
  projectDir = ./.;
}).python.pkgs.nsz
