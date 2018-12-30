{ pkgs, ... }:

{

  home.file.".emacs".source = ./dotfiles/emacs.el;

  home.sessionVariables.EDITOR = "emacsclient";

  home.packages = [
    ((import ./dotfiles/elisp.nix { inherit pkgs; }).fromEmacsUsePackage {
      configPath = ./dotfiles/emacs.el;
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
