{ emacsWithPackagesFromUsePackage
, pkgs
}:

emacsWithPackagesFromUsePackage {
  # package = pkgs.emacsUnstable;

  config = builtins.readFile ./emacs.el;

  alwaysEnsure = true;

  override = epkgs: epkgs // {

    weechat = epkgs.melpaPackages.weechat.overrideAttrs(old: {
      patches = [ ./weechat-el.patch ];
    });

  };
}
