{ emacsWithPackagesFromUsePackage
, pkgs
}:

emacsWithPackagesFromUsePackage {
  package = pkgs.emacsGcc;

  config = ./emacs.el;

  alwaysEnsure = true;

}
