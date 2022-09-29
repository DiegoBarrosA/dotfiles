{ config, pkgs, lib, ... }: {
  config = {

    nixpkgs.config.allowUnfreePredicate = true;
    environment.systemPackages = with pkgs; [
      bluez-tools
      brightnessctl
      btop
      cava
      chezmoi
      cmake
      cmatrix
      ddcutil
      exa
      fdupes
      ffmpeg
      git
      glow
      gping
      imagemagick
      jq
      libnotify
      libsecret
      mpc_cli
      ncmpcpp
      neofetch
      nixfmt
      nodePackages.coc-prettier
      nodejs
      openssl
      pfetch
      pipes-rs
      procs
      pulseaudio
      pv
      python3
      ranger
      slurp
      starship
      stow
      unzip
      wget
      xdg-user-dirs
      yt-dlp
      zip
      zoxide
      android-tools
      unrar
    ];
    nixpkgs.overlays = [
      (self: super: {
        ncmpcpp = super.ncmpcpp.override {
          visualizerSupport = true;
          clockSupport = true;
        };
      })
    ];

  };
}
