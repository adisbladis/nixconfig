{ stdenv
, buildPythonApplication
, fetchFromGitHub
, ffmpeg_4
, lib
}:

buildPythonApplication rec {
  pname = "bulkrecode";
  version = "unstable-2016-09-17";

  src = fetchFromGitHub {
    owner = "adisbladis";
    repo = "bulkrecode";
    rev = "12d0315602e9b08e40a5d61670fee101adcc6347";
    sha256 = "10lmfwdldkjyqnygpq6lncyly4g38bpl527kj5zzpqxd5c03x3v4";
  };

  propagatedBuildInputs = [
    ffmpeg_4
  ];

  meta = {
    license = lib.licenses.gpl3;
  };
}
