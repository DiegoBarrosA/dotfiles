{ config, pkgs, ... }: {
  config = {
    nixpkgs.config.allowUnfree = true;
    environment.systemPackages = with pkgs; [
      keepassxc
      obs-studio
      vscodium
      ungoogled-chromium
      openrgb
      androidStudioPackages.beta
      androidStudioPackages.canary
      qbittorrent
      krita
      gimp
      inkscape
      onlyoffice-bin
    ];

  };
}
