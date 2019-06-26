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
        "2048-game" = epkgs._2048-game;
        weechat = epkgs.melpaPackages.weechat;
        magit-org-todos = (epkgs.melpaPackages.magit-org-todos.overrideAttrs(oldAttrs: {
          buildInputs = oldAttrs.buildInputs ++ [ pkgs.git ];
        }));
        # realgud = (epkgs.melpaPackages.realgud.overrideAttrs(oldAttrs: {
        #   buildInputs = oldAttrs.buildInputs ++ [ pkgs.clang ];
        # }));
        vterm = epkgs.emacs-libvterm;
        nix-mode = epkgs.nix-mode.overrideAttrs(old: {
          src = ./emacs-modes/nix-mode;
        });
      };
    })
  ];

}
