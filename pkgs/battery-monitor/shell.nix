{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell {
  packages = [
    pkgs.rustc
    pkgs.cargo
  ];

  buildInputs = [
    pkgs.libnotify
  ];
}
