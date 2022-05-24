{ lib ? pkgs.lib
, pkgs ? import <nixpkgs> { }
}:

let
  inherit (pkgs) lib;

in
pkgs.naersk.buildPackage {
  pname = "battery-monitor";
  version = "dev";
  src = lib.cleanSource ./.;
  # cargoSha256 = "sha256-27w/UrLt7MKBzAD7O+oVfUxgAPcEGLZy48GyYoV5Y8g=";
  buildInputs = [
    pkgs.libnotify
  ];
}
