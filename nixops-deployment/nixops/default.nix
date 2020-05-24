{ pkgs ? import ../../nixpkgs {} }:

(pkgs.poetry2nix.mkPoetryPackages {
  projectDir = ./.;
  overrides = pkgs.poetry2nix.overrides.withDefaults(self: super: {
    nixops = self.toPythonApplication (super.nixops.overridePythonAttrs(old: {
      buildInputs = old.buildInputs ++ [
        self.poetry
      ];
    }));
  });
}).python.pkgs.nixops
