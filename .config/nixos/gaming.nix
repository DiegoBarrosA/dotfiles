{ config, pkgs, lib, ... }: {
  config = {
    environment.systemPackages = with pkgs; [
      steam-tui
      superTuxKart
      lutris
      minetest
      prismlauncher
      retroarchFull
    ];
    nixpkgs.config.allowUnfree = true;
    programs.steam = {
      enable = true;
      remotePlay.openFirewall =
        true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall =
        true; # Open ports in the firewall for Source Dedicated Server
    };

  };

}

