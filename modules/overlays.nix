{ config, ... }:

{
  nixpkgs.overlays = [
    (import ../third_party/emacs-overlay)
  ];
}
