{ config, pkgs, ... }: {
  config = {
    nixpkgs.config.allowUnfree = true;
    environment.systemPackages = with pkgs; [
      keepassxc
      obs-studio
      vscodium
      ungoogled-chromium
      openrgb
      krita
      gimp
      inkscape
      zoom-us
      libreoffice-fresh
    ];

  };
}
