{ stdenv
, lib
, buildGoPackage
, makeWrapper
, udev
, openssh
}:

buildGoPackage rec {
  name = "pkcs11-ssh-hotplug-watcher";
  version = "unstable-2018-10-14";
  goPackagePath = "github.com/adisbladis/pkcs-ssh-agent";

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ udev ];

  src = lib.cleanSource ./.;

  goDeps = ./deps.nix;

  postInstall = with stdenv; let
    binPath = lib.makeBinPath [ openssh ];
  in ''
    wrapProgram $bin/bin/pkcs-ssh-agent --prefix PATH : ${binPath}
  '';

  meta = with stdenv.lib; {
    license = licenses.mit;
    maintainers = with maintainers; [ adisbladis ];
  };

}
