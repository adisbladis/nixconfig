{ pkgs ? import <nixpkgs> { } }:
let
  pythonEnv = pkgs.poetry2nix.mkPoetryEnv {
    projectDir = ./.;
    overrides = pkgs.poetry2nix.overrides.withDefaults (
      self: super: {

        notify-py = super.notify-py.overridePythonAttrs (
          old: {
            nativeBuildInputs = old.nativeBuildInputs ++ [
              self.poetry-core
            ];
          }
        );

      }
    );
  };

in (pkgs.writeScript "battery-monitor" ''
  #!${pkgs.runtimeShell}
  exec ${pythonEnv.interpreter} ${./battery-monitor.py}
'').overrideAttrs(old: {
  passthru = {
    inherit pythonEnv;
  };
})
