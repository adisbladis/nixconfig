{ pkgs, ... }:

{

  home.file.".emacs".source = ./dotfiles/emacs.el;

  home.sessionVariables.EDITOR = "emacsclient";
  home.sessionVariables.XMODIFIERS = "@im=exim";
  home.sessionVariables.GTK_IM_MODULE = "xim";
  home.sessionVariables.QT_IM_MODULE = "xim";
  home.sessionVariables.CLUTTER_IM_MODULE = "xim";

  home.packages = [
    (pkgs.emacsWithPackagesFromUsePackage {
      # package = pkgs.emacsGit;
      config = builtins.readFile ./dotfiles/emacs.el;
      override = epkgs: epkgs // {
        weechat = epkgs.melpaPackages.weechat.overrideAttrs(old: {
          patches = [ ./weechat-el.patch ];
        });
        magit-org-todos = (epkgs.melpaPackages.magit-org-todos.overrideAttrs(oldAttrs: {
          buildInputs = oldAttrs.buildInputs ++ [ pkgs.git ];
        }));
        vterm = epkgs.emacs-libvterm;
        nix-mode = epkgs.nix-mode.overrideAttrs(old: {
          src = ./emacs-modes/nix-mode;
        });
      };
    })
  ];

}
