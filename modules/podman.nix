{ config, lib, pkgs, ... }:

let
  cfg = config.my.podman;

  # Provides a fake "docker" binary mapping to podman
  dockerCompat = pkgs.runCommandNoCC "docker-podman-compat" {} ''
    mkdir -p $out/bin
    ln -s ${pkgs.podman}/bin/podman $out/bin/docker
  '';

in {

  options.my.podman.enable = lib.mkEnableOption "Enables global settings required by podman.";

  config = lib.mkIf cfg.enable {

    environment.systemPackages = [
      dockerCompat
      pkgs.podman  # Docker compat
      pkgs.runc  # Container runtime
      pkgs.conmon  # Container runtime monitor
      pkgs.skopeo  # Interact with container registry
      pkgs.slirp4netns  # User-mode networking for unprivileged namespaces
      pkgs.fuse-overlayfs  # CoW for images, much faster than default vfs
    ];

    users.extraUsers.adisbladis = {
      subUidRanges = [{ startUid = 100000; count = 65536; }];
      subGidRanges = [{ startGid = 100000; count = 65536; }];
    };

  };

}
