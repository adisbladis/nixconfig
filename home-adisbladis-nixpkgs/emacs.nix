{ pkgs, ... }:

{

  home.file.".emacs".source = ./dotfiles/emacs.el;

  home.sessionVariables.EDITOR = "emacsclient";
  home.sessionVariables.XMODIFIERS = "@im=exim";
  home.sessionVariables.GTK_IM_MODULE = "xim";
  home.sessionVariables.QT_IM_MODULE = "xim";
  home.sessionVariables.CLUTTER_IM_MODULE = "xim";

  home.packages = [
    ((import ./dotfiles/elisp.nix { inherit pkgs; }).fromEmacsUsePackage {
      config = builtins.readFile ./dotfiles/emacs.el;
      override = epkgs: epkgs // {
        weechat = epkgs.melpaPackages.weechat;
        magit-org-todos = (epkgs.melpaPackages.magit-org-todos.overrideAttrs(oldAttrs: {
          buildInputs = oldAttrs.buildInputs ++ [ pkgs.git ];
        }));
        vterm = epkgs.emacs-libvterm;
      };
    })
  ];

}
