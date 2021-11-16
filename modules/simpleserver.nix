{ config, lib, pkgs, ... }:

let
  inherit (lib) mkOption types;

  cfg = config.my.simpleserver;
  simpleserver = cfg.package;

  pkg = pkgs.callPackage
    (
      { stdenv, buildGoPackage, fetchFromGitHub, libcap, lib }:

      buildGoPackage rec {
        name = "simpleserver-${version}";
        version = "unstable-0.1";
        goPackagePath = "github.com/adisbladis/simpleserver";

        buildInputs = [ libcap ];

        src = fetchFromGitHub {
          owner = "adisbladis";
          repo = "simpleserver";
          rev = "c81d065d990ff22479756c9a0416580d84ac5179";
          sha256 = "19y3j3fg8ccy574j0aswh4bna0cx14abdy2fsl0x0iw56nqfaznv";
        };

        meta = {
          homepage = https://github.com/adisbladis/simpleserver;
          description = " A simple directory listing webserver ";
          license = [ lib.licenses.mit ];
          maintainers = [ lib.maintainers.adisbladis ];
          platforms = lib.platforms.linux;
        };
      }
    )
    { };


in
{
  options.my.simpleserver = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        A simple directory listing webserver
      '';
    };

    package = mkOption {
      type = types.package;
      default = pkg;
      defaultText = "pkgs.simpleserver";
      description = "simpleserver derivation to use.";
    };

  };

  config = lib.mkIf cfg.enable {
    security.wrappers.simpleserver = {
      source = "${simpleserver}/bin/simpleserver";
      owner = "root";
      group = "root";
      capabilities = "cap_sys_chroot+ep";
    };
  };
}

