{ config, lib, pkgs, ... }:

let

  cfg = config.services.activated-tunnels;

  fmtName = n: "activated-tunnel-${n}";

  package = import ../overlays/local/pkgs/activated-tunnel { inherit pkgs; };

  mkCommandline = options:
    [ "${package}/bin/activated-tunnel" ]
    ++ [ "--host" options.host ]
    ++ [ "--port" (builtins.toString options.port) ]
    ++ lib.optionals (options.user != null) [ "--user" options.user ]
    ++ [ options.type ]
    ++ lib.optionals (options.type == "port") [
      "--host" options.portOptions.host
      "--port" (builtins.toString options.portOptions.port)
    ]
  ;

in {

  options.services.activated-tunnels = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule ({ name, config, ... }: {
      options = {

        bind = lib.mkOption {
          type = lib.types.str;
          description = "Bind socket to this address.";
          example = "127.0.0.1:5000";
        };

        host = lib.mkOption {
          type = lib.types.str;
          description = "Remote hostname.";
        };

        port = lib.mkOption {
          type = lib.types.int;
          description = "Remote port.";
          default = 22;
        };

        user = lib.mkOption {
          default = null;
          type = lib.types.nullOr lib.types.str;
          description = "SSH username (if different from $USER).";
        };

        type = lib.mkOption {
          default = "default";
          type = lib.types.enum [ "port" "socks" ];
          description = "Forward type.";
        };

        portOptions = lib.mkOption {
          default = {};
          description = "Port forward options (not used for socks).";
          type = lib.types.submodule {
            options = {
              host = lib.mkOption {
                type = lib.types.str;
                default = "localhost";
                description = "Forward host.";
              };
              port = lib.mkOption {
                type = lib.types.int;
                description = "Remote port.";
              };
            };
          };
        };

      };
    }));
  };

  config = {
    systemd.user = {

      services = lib.listToAttrs (lib.mapAttrsToList (n: v: let
        name = fmtName n;
      in {
        inherit name;
        value = {
          Unit = {
            Description = "Socket activated link ${n}";
            Requires = "${name}.socket";
            After = "${name}.socket";
            RefuseManualStart = true;
          };

          Service = {
            ExecStart = mkCommandline v;
            PrivateTmp = true;
            ProtectSystem = "strict";
            ProtectHome = "read-only";
          };
        };
      }) cfg);

      sockets = lib.listToAttrs (lib.mapAttrsToList (n: v: let
        name = fmtName n;
      in {
        inherit name;
        value = {
          Unit = { Description = "Socket for activated link ${n}"; };

          Socket = {
            ListenStream = v.bind;
          };

          Install = { WantedBy = [ "sockets.target" ]; };

        };
      }) cfg);

    };
  };

}
