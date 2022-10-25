{ config, lib, pkgs, stdenv, ... }:
let
  version = "2021.3.1.17";
  filename = "android-studio-${version}-linux.tar.gz";
  sha256Hash =
    "89adb0ce0ffa46b7894e7bfedb142b1f5d52c43c171e6a6cb9a95a49f77756ca";
in {

  environment.systemPackages = [
    (self: super: {
      pkgs.android-studio-current = super.android-studio.override {
        src = super.fetchurl {
          url =
            "https://dl.google.com/dl/android/studio/ide-zips/${version}/${filename}";
          sha256 = sha256Hash;
        };
      };

    })
  ];

}
