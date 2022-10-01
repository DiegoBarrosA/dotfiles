{ config, pkgs, ... }: {
  services = {
    syncthing = {
      enable = true;
      user = "diego";
      dataDir = "/storage/var/lib/syncthing";
      configDir = "/home/diego/.config/syncthing";
    };
    printing = {
      enable = true;
      drivers = [ pkgs.brlaser ];
    };
    transmission = {
      enable = true;
      user = "diego";
      home = "/storage/var/lib/transmission";
      settings = {
        download-dir = "${config.services.transmission.home}/downloads";
        incomplete-dir = "${config.services.transmission.home}/incomplete";
        watch-dir-enabled = true;
        watch-dir = "${config.services.transmission.home}/watchdir";
        trash-original-torrent-files = true;

      };
    };
    openssh.enable = true;
    flatpak.enable = true;
    onedrive.enable = true;
    gvfs.enable = true;
    devmon.enable = true;
    usbmuxd.enable = true;
    udisks2.enable = true;
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
  };
  environment.systemPackages = with pkgs; [ libimobiledevice ifuse ];

  hardware.bluetooth.enable = true;
  hardware.bluetooth.package = pkgs.bluez5-experimental;
  systemd.services.mpd.environment = { XDG_RUNTIME_DIR = "/run/user/1000"; };

}

