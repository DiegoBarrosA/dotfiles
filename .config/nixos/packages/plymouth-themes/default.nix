{ pkgs ? import <nixpkgs> { } }:
pkgs.stdenv.mkDerivation rec {
  pname = "plymouth-themes";
  version = "0.0.1";

  src = pkgs.fetchFromGitHub {

    owner = "adi1090x";
    repo = "plymouth-themes";
    rev = "bf2f570bee8e84c5c20caac353cbe1d811a4745f";
    sha256 = "VNGvA8ujwjpC2rTVZKrXni2GjfiZk7AgAn4ZB4Baj2k=";

  };

  buildInputs = [ pkgs.git ];

  configurePhase = ''
    mkdir -p $out/share/plymouth/themes/
  '';

  buildPhase = "";

  installPhase = ''
      cp -r pack_3/loader_2 $out/share/plymouth/themes
    cat pack_3/loader_2/loader_2.plymouth | sed  "s@\/usr\/@$out\/@" > $out/share/plymouth/themes/loader_2/loader_2.plymouth
  '';
}
