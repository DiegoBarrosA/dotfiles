{ config, pkgs, callPackage, lib, ... }: {
  services.emacs = {
    package = pkgs.emacsPgtkNativeComp;
    enable = true;
  };

  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url =
        "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz";
    }))
  ];
  environment.systemPackages = with pkgs; [
    ((emacsPackagesFor emacs).emacsWithPackages
      (epkgs: [ epkgs.vterm ])) # #Fundamentals
    ripgrep
    fd
    fzf
    ##formating

    shellcheck
    ispell
    black
    shfmt
    ##utils
    ##Python
    python39Packages.pyflakes
    python39Packages.isort
    pipenv
    python39Packages.nose
    python39Packages.pytest
    python39Packages.setuptools
    ###MarkDown
    pandoc
    ###HTML
    html-tidy
    ###CSS
    nodePackages.stylelint
    ###CSS
    nodePackages.js-beautify
    tetex
  ];
}
