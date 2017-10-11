{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.simpleserver;
  simpleserver = cfg.package;

in {
  options = {
    programs.simpleserver = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
           A simple directory listing webserver
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.simpleserver;
        defaultText = "pkgs.simpleserver";
        description = "simpleserver derivation to use.";
      };

    };
  };

  config = mkIf cfg.enable {
    security.wrappers.simpleserver = {
      source = "${simpleserver}/bin/simpleserver";
      capabilities = "cap_sys_chroot+ep";
    };
  };
}
