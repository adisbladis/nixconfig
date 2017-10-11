{ stdenv, buildGoPackage, fetchFromGitHub, libcap }:

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

  meta = with stdenv.lib; {
    homepage = https://github.com/adisbladis/simpleserver;
    description = " A simple directory listing webserver ";
    license = with licenses; [ mit ];
    maintainers = [ maintainers.adisbladis ];
    platforms = platforms.linux;
  };
}
