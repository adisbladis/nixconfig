{ pkgs ? import ../nixpkgs {} }:

pkgs.mkShell {
  buildInputs = [
    (import ./nixops { inherit pkgs; })
  ];
}
