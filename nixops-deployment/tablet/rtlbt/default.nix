{ stdenv, lib, fetchFromGitHub, kernel }:

with lib;

let modDestDir = "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/wireless/realtek/rtlwifi";

in stdenv.mkDerivation rec {
  name = "rtl8723bs_bt-${version}";
  version = "2016-07-18";

  src = fetchFromGitHub {
    owner = "lwfinger";
    repo = "rtlwifi_new";
    rev = "09eb91f52a639ec5e4c5c4c98dc2afede046cf20";
    sha256 = "0b7mvvsdsih48nb3dgknfd9xj5h38q8wyspxi7h0hynb8szjjda4";
  };

  hardeningDisable = [ "pic" "format" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = "KSRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";

  enableParallelBuilding = true;

  installPhase = ''
    mkdir -p ${modDestDir}
    find . -name '*.ko' -exec cp --parents {} ${modDestDir} \;
    find ${modDestDir} -name '*.ko' -exec xz -f {} \;
  '';

  meta = {
    description = "";
    inherit (src.meta) homepage;
    license = licenses.gpl2;
    platforms = [ platforms.linux ];
    maintainers = [ maintainers.tvorog ];
    priority = -1;
  };
}
