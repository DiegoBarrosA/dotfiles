{ config, pkgs, ... }: {
  config = {
    nixpkgs.config.allowUnfree = true;
    environment.systemPackages = with pkgs; [
      keepassxc
      yacreader
      qrencode
      obs-studio
      vscodium
      ungoogled-chromium
      openrgb
      androidStudioPackages.beta
      androidStudioPackages.canary
      krita
      gimp
      inkscape
      zoom-us
      libreoffice-fresh
    ];

  };
}
