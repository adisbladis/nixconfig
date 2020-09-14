{ emacsWithPackagesFromUsePackage
, pkgs
}:

emacsWithPackagesFromUsePackage {
  package = pkgs.emacsGit;

  config = ./emacs.el;

  alwaysEnsure = true;

}
