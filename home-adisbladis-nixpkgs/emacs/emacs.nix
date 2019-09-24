{ emacsWithPackagesFromUsePackage
, pkgs
}:

emacsWithPackagesFromUsePackage {
  # package = pkgs.emacsGit;

  config = builtins.readFile ./emacs.el;

  override = epkgs: epkgs // {

    weechat = epkgs.melpaPackages.weechat.overrideAttrs(old: {
      patches = [ ./weechat-el.patch ];
    });

  };
}
