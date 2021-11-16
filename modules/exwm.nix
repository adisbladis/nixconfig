{ config, pkgs, lib, ... }:

let
  cfg = config.my.exwm;
in
{

  options.my.exwm.enable = lib.mkEnableOption "Enable exwm options.";

  config = lib.mkIf cfg.enable {

    my.emacs.enable = true;

    services.xserver.enable = true;

    services.xserver.layout = "us";
    services.xserver.xkbOptions = "ctrl:nocaps";
    services.xserver.xkbVariant = "dvorak";

    services.xserver.displayManager.defaultSession = "none+xsession";

    services.xserver.displayManager.autoLogin.user = "adisbladis";
    services.xserver.displayManager.autoLogin.enable = true;

    services.xserver.displayManager.lightdm.enable = true;


    services.xserver.windowManager.session = lib.singleton {
      name = "xsession";
      start = pkgs.writeScript "xsession" ''
        #!${pkgs.runtimeShell}
        if test -f $HOME/.xsession; then
          exec ${pkgs.runtimeShell} -c $HOME/.xsession
        else
          echo "No xsession script found"
          exit 1
        fi
      '';
    };

    home-manager.users.adisbladis = { ... }:
      let
        sessionVariables = {
          EDITOR = "emacsclient";
          XMODIFIERS = "@im=exwm-xim";
          GTK_IM_MODULE = "xim";
          QT_IM_MODULE = "xim";
          CLUTTER_IM_MODULE = "xim";
        };
      in
      {
        xsession.enable = true;
        xsession.windowManager.command = "emacs";
        home.sessionVariables = sessionVariables // {
          # Fix stupid java applications like android studio
          _JAVA_AWT_WM_NONREPARENTING = "1";
        };
        xsession.importedVariables = lib.attrNames sessionVariables;
        xsession.profileExtra =
          let
            mkExport = n: v: "export ${n}='${v}'";
            x = lib.concatStringsSep "\n" (lib.mapAttrsToList mkExport sessionVariables);
          in
          ''
            ${lib.concatStringsSep "\n" (lib.mapAttrsToList mkExport sessionVariables)}
            systemctl --user import-environment ${lib.concatStringsSep " " (lib.attrNames sessionVariables)}
          '';
      };

  };

}
