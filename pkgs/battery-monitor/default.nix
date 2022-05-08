{ pkgs ? import <nixpkgs> { } }:
let
  pythonEnv = pkgs.python3.withPackages(ps: [
    ps.psutil
    ps.notify-py
  ]);

in (pkgs.writeScript "battery-monitor" ''
  #!${pkgs.runtimeShell}
  exec ${pythonEnv.interpreter} ${./battery-monitor.py}
'').overrideAttrs(old: {
  passthru = {
    inherit pythonEnv;
  };
})
