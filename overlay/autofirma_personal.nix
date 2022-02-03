{ stdenv, lib, fetchurl, unzip, dpkg, makeWrapper, jre }:
let
  version = "1.6.5";
  src =
    fetchurl {
      url = "http://estaticos.redsara.es/comunes/autofirma/currentversion/AutoFirma_Linux.zip";
      sha256 = "1zys8sl03fbh9w8b2kv7xldfsrz53yrhjw3yn45bdxzpk7yh4f5j";
    };
in
stdenv.mkDerivation {
  name = "autofirma-${version}";
  inherit src;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ unzip dpkg ];

  unpackPhase = "true";
  installPhase = ''
    mkdir -p $out
    unzip $src "*.deb"
    dpkg -x AutoFirma_1_6_5.deb $out
    cp -av $out/usr/* $out
    # TODO: install /etc/firefox/pref/AutoFirma.js
    # TODO: copy only necessary files
    rm -rf $out/usr $out/etc $out/bin/AutoFirma $out/lib/AutoFirma/AutoFirmaConfigurador.jar

    sed -i -e "s,/usr/bin,$out/bin,g" -e "s,/usr/lib,$out/lib,g" $out/share/applications/afirma.desktop

    makeWrapper ${jre}/bin/java $out/bin/AutoFirma \
      --add-flags "-jar $out/lib/AutoFirma/AutoFirma.jar"
    chmod 0555 -R $out #fix permissions
  '';

  meta = with lib; {
    description = "Spanish Government digital signature client";
    homepage = "http://firmaelectronica.gob.es";
    license = [ licenses.gpl2 licenses.eupl11 ];
    platforms = platforms.all;
  };
}
