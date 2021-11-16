{ config, lib, ... }:

{
  imports = map (x: ./. + "/${x}") (
    lib.attrNames (
      lib.filterAttrs
        (
          n: t: n != "default.nix" && (
            t == "directory" || lib.hasSuffix ".nix" n
          )
        )
        (builtins.readDir ./.)
    )
  );
}
