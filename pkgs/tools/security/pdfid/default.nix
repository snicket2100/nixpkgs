{ stdenv, fetchurl, unzip, makeWrapper, python3 }:

stdenv.mkDerivation rec {
  name = "pdfid";
  version = "0.2.7";

  src = fetchurl {
    url = "https://didierstevens.com/files/software/${name}_v${builtins.replaceStrings ["."] ["_"] version}.zip";
    sha256 = "0q3fvfd7sf2fmh3hjj3v9gfnn0vfafqmy2a03bww3jwf8pz5jazy";
  };

  # Work around the "unpacker appears to have produced no directories"
  # case that happens when the archive doesn't have a subdirectory.
  setSourceRoot = "sourceRoot=`pwd`";

  nativeBuildInputs = [ unzip makeWrapper ];
  propagatedBuildInputs = [ python3 ];

  installPhase = ''
    mkdir -p $out/libexec
    cp *.ini *.py $out/libexec
    chmod a+x $out/libexec/*.py
    makeWrapper $out/libexec/pdfid.py $out/bin/pdfid
  '';

  meta = with stdenv.lib; {
    homepage = "https://blog.didierstevens.com/programs/pdf-tools/";
    description = "Identifies potentially dangerous features used by PDF documents (like JavaScript, open actions etc.)";
    maintainers = with maintainers; [ snicket2100 ];
    platforms = platforms.linux;
    license = licenses.publicDomain;
  };
}
