{ pkgs ? import <nixpkgs> { } }:

let
  inherit (pkgs) rustPlatform lib;

in rustPlatform.buildRustPackage {
  pname = "battery-monitor";
  version = "dev";
  src = lib.cleanSource ./.;
  cargoSha256 = "sha256-27w/UrLt7MKBzAD7O+oVfUxgAPcEGLZy48GyYoV5Y8g=";
  buildInputs = [
    pkgs.libnotify
  ];
}
