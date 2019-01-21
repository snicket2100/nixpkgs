{ stdenv, fetchFromGitHub, pkgconfig
, buildGoPackage, gpgme, lvm2, btrfs-progs, libseccomp
}:

buildGoPackage rec {
  name = "podman-${version}";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "libpod";
    rev = "v${version}";
    sha256 = "1py6vbmpm25j1gb51dn973pckvgjl9q63y9qyzszvc3q3wsxsqhw";
  };

  goPackagePath = "github.com/containers/libpod";

  # Optimizations break compilation of libseccomp c bindings
  hardeningDisable = [ "fortify" ];
  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [
    btrfs-progs libseccomp gpgme lvm2
  ];

  buildPhase = ''
    pushd $NIX_BUILD_TOP/go/src/${goPackagePath}
    patchShebangs .
    make binaries
  '';

  installPhase = ''
    install -Dm555 bin/podman $bin/bin/podman
  '';

  meta = with stdenv.lib; {
    homepage = https://podman.io/;
    description = "A program for managing pods, containers and container images";
    license = licenses.asl20;
    maintainers = with maintainers; [ vdemeester ];
    platforms = platforms.linux;
  };
}
