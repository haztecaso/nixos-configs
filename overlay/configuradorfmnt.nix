{ stdenv, lib, fetchurl, dpkg, makeWrapper, jre8 }:
let
  pname = "configuradorfnmt";
  version = "1.0.1";
  install_cmd = file: "install -Dvm644 ./usr/${file} $out/${file}";
in
stdenv.mkDerivation {
  inherit version pname;

  src = fetchurl {
    url = "https://descargas.cert.fnmt.es/Linux/configuradorfnmt_${version}-0_amd64.deb";
    sha256 = "0f7kfipmrmsahrr6p3783vdqq7vmgkjgqqgnznwjnlzj2y0gafhw";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ dpkg ];

  unpackPhase = "dpkg -x $src .";
  installPhase = ''
    rm ./usr/lib/configuradorfnmt/jre.tar.gz ./usr/bin/configuradorfnmt

    mkdir -p $out/lib/configuradorfnmt $out/bin $out/share/applications

    sed -i -e "s,/usr/bin,$out/bin,g"\
         -e "s,/usr/lib,$out/lib,g"\
         ./usr/share/applications/configuradorfnmt.desktop

    ${install_cmd "lib/configuradorfnmt/configuradorfnmt.jar"}
    ${install_cmd "lib/configuradorfnmt/configuradorfnmt.js"}
    ${install_cmd "lib/configuradorfnmt/configuradorfnmt.png"}
    ${install_cmd "share/applications/configuradorfnmt.desktop"}

    makeWrapper ${jre8}/bin/java $out/bin/configuradorfnmt \
    --add-flags "-jar $out/lib/configuradorfnmt/configuradorfnmt.jar"

    rm -rf usr
  '';

  meta = with lib; {
    description = "Tool for requesting Spanish official keys and certificates";
    homepage = "https://www.sede.fnmt.gob.es/descargas/descarga-software/instalacion-software-generacion-de-claves";
    license = licenses.unfree; #no upstream license
    platforms = platforms.linux;
  };
}
