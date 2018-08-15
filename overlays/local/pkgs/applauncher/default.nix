{ stdenv, buildGoPackage }:

buildGoPackage rec {
  name = "applauncher-${version}";
  version = "0.0.1";
  goPackagePath = "github.com/adisbladis/nixconfig/overlays/local/pkgs/applauncher";

  goDeps = ./deps.nix;
  src = ./.;

  meta = with stdenv.lib; {
    license = with licenses; [ gpl3 ];
    maintainers = [ maintainers.adisbladis ];
  };
}
