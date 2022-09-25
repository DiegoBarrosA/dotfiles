{ config, pkgs, ... }: {
  services = {
    syncthing = {
      enable = true;
      user = "diego";
      dataDir = "/home/diego";
      configDir = "/home/diego/.config/syncthing";
    };
    printing = {
      enable = true;
      drivers = [ pkgs.brlaser ];
    };
    openssh.enable = true;
    flatpak.enable = true;
    onedrive.enable = true;
    gvfs.enable = true;
    devmon.enable = true;
    usbmuxd.enable = true;
    services.udisks2.enable = true;
    gnome.gnome-keyring.enable = true;
    mpd = {
      enable = true;
      user = "diego";
      musicDirectory = "/home/diego/Music";
      extraConfig = ''
          audio_output {
           type "pipewire"
           name "My PipeWire Output"
         } 
          audio_output {
              type            "fifo"
               name            "Visualizer feed"
                path            "/tmp/mpd.fifo"
               format          "44100:16:2"
        }
      '';

      network.listenAddress = "any";
      startWhenNeeded = true;
    };
    transmission = {
      enable = true;
      home = "/home/diego/Downloads/Torrenting";
      settings.watch-dir = "/home/diego/Downloads";

    };
  };
  environment.systemPackages = with pkgs; [ libimobiledevice ifuse ];

  hardware.bluetooth.enable = true;
  hardware.bluetooth.package = pkgs.bluez5-experimental;
  systemd.services.mpd.environment = { XDG_RUNTIME_DIR = "/run/user/1000"; };

}

