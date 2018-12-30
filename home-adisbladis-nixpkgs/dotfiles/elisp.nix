{ pkgs }:
with pkgs;

let
  isStrEmpty = s: (builtins.replaceStrings [" "] [""] s) == "";

  stripComments = dotEmacs: let
    lines = lib.splitString "\n" dotEmacs;
    stripped = builtins.map (l:
      lib.elemAt (lib.splitString ";;" l) 0) lines;
  in lib.concatStringsSep " " stripped;

  parsePackages = dotEmacs: let
    strippedComments = stripComments dotEmacs;
    tokens = builtins.filter (t: !(isStrEmpty t)) (builtins.map
      (t: if builtins.typeOf t == "list" then lib.elemAt t 0 else t)
      (builtins.split "([\(\)])" strippedComments));
    matches = builtins.map (t:
      builtins.match "^use-package[[:space:]]+([A-Za-z0-9_-]+).*" t) tokens;
    pkgs = builtins.map (m: lib.elemAt m 0)
      (builtins.filter (m: m != null) matches);
  in pkgs;

  fromEmacsUsePackage = { package ? pkgs.emacs, configPath, override ? (epkgs: epkgs) }: let
    dotEmacs = builtins.readFile configPath;
    packages = parsePackages dotEmacs;
    emacsPackages = pkgs.emacsPackagesNgGen package;
    emacsWithPackages = emacsPackages.emacsWithPackages;
  in emacsWithPackages (epkgs: let
    overriden = override epkgs;
  in builtins.map (name: overriden.${name}) (packages ++ [ "use-package" ]));

in {
  inherit fromEmacsUsePackage;
}
