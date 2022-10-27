{ config, pkgs, lib, ... }:
let
  unstable = import
    (builtins.fetchTarball "https://github.com/nixos/nixpkgs/tarball/master")
    # reuse the current configuration
    { config = config.nixpkgs.config; };
  dbus-sway-environment = pkgs.writeTextFile {
    name = "dbus-sway-environment";
    destination = "/bin/dbus-sway-environment";
    executable = true;

    text = ''
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
      systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
      systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
    '';
  };
  sway-polkit = pkgs.writeTextFile {
    name = "sway-polkit";
    destination = "/bin/sway-polkit";
    executable = true;

    text = ''
      exec ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1
    '';

  };
  win10-session = pkgs.writeTextFile {
    name = "win10-session";
    destination = "/bin/win10-session";
    executable = true;

    text = ''
      #!/bin/sh
      if (virsh list --state-running | grep win10); then

          win10=$(virt-viewer --attach -k --kiosk-quit=on-disconnect --domain-name win10)
      else
          win10=$(virsh start win10 && virt-viewer --attach -k --kiosk-quit=on-disconnect --domain-name win10)
      fi

      exec "$win10"

      exit
    '';

  };

  style-greet = pkgs.writeTextFile {
    name = "style-greet";
    destination = "/etc/greet.css";

    text = ''
      @import url("${pkgs.materia-theme}/share/themes/Materia-dark/gtk-3.0/gtk.css");
               *{
            font: 16px "Jost*";
                }
                            window {
                                background-image: url("file://${background-greet}");
                                background-size: cover;
                                background-position: center;
                             }

                              box#body {
                                background-color: rgba(50, 50, 50, 0);
                                border-radius: 10px;
                                padding: 50px;
                             }
    '';
  };
  background-greet = pkgs.fetchurl {
    url =
      "https://raw.githubusercontent.com/DiegoBarrosA/dotfiles/current/.local/share/backgrounds/nix-wallpaper-nineish-dark-gray.png";
    sha256 = "nhIUtCy/Hb8UbuxXeL3l3FMausjQrnjTVi1B3GkL9B8=";
  };
  configure-gtk = pkgs.writeTextFile {
    name = "configure-gtk";
    destination = "/bin/configure-gtk";
    executable = true;
    text = let
      schema = pkgs.gsettings-desktop-schemas;
      datadir = "${schema}/share/gsettings-schemas/${schema.name}";
    in ''
      gnome_schema=org.gnome.desktop.interface
      export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
      gsettings set $gnome_schema gtk-theme 'Materia-dark'
      gsettings set $gnome_schema icon-theme 'Papirus-Dark'
      gsettings set $gnome_schema cursor-theme 'capitaine-cursors'
      gsettings set $gnome_schema font-name 'Jost* 12'
      gsettings set $gnome_schema cursor-size 32
      gsettings set org.gtk.Settings.FileChooser startup-mode cwd

    '';
  };
  greetd-sway-config = pkgs.writeTextFile {
    name = "greetd-sway-config";
    destination = "/etc/config";

    text = ''
      exec "${dbus-sway-environment}/bin/dbus-sway-environment"
      exec "${configure-gtk}/bin/configure-gtk"
      exec "${pkgs.greetd.gtkgreet}/bin/gtkgreet -l -s ${style-greet}/etc/greet.css  -c sway; swaymsg exit"
      seat seat0 xcursor_theme "capitaine-cursors" 32
      bindsym Mod4+shift+e exec swaynag \
        -t warning \
        -m 'What do you want to do?' \
        -b 'Poweroff' 'systemctl poweroff' \
        -b 'Reboot' 'systemctl reboot'

    '';
  };

in {
  services.greetd = {
    enable = true;
    package = pkgs.greetd.gtkgreet;
    settings = {
      default_session = {
        command =
          "${pkgs.sway}/bin/sway --config ${greetd-sway-config}/etc/config";
        user = "greeter";
      };
    };
  };
  environment.etc."greetd/environments".text = ''
    sway
    cage win10-session
    fish
    bash
  '';
  security.pam.services.greetd.enableGnomeKeyring = true;
  security.polkit.enable = true;
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraSessionCommands = ''
      export SDL_VIDEODRIVER=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      export CLUTTER_BACKEND=wayland
      export SDL_VIDEODRIVER=wayland
      export MOZ_ENABLE_WAYLAND=1
      export QT_WAYLAND_FORCE_DPI=physical
      export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
      export GTK_THEME="Materia-dark"
      export BROWSER=firefox
      export TERM=alacritty
      export NO_AT_BRIDGE=1
      export QT_QPA_PLATFORM=wayland-egl
      export SAL_USE_VCLPLUGIN=gtk3
      ##JAVA
      export _JAVA_AWT_WM_NONREPARENTING=1
      export ECORE_EVAS_ENGINE=wayland_egl
      export ELM_ENGINE=wayland_egl


    '';
    extraPackages = with pkgs; [
      win10-session
      qt5.qtwayland
      greetd.gtkgreet
      kitty
      ario
      autotiling
      capitaine-cursors
      clipman
      configure-gtk
      dbus-sway-environment
      firefox-wayland
      gnome3.adwaita-icon-theme
      glib
      greetd.gtkgreet
      grim
      gtk-engine-murrine
      imv
      kanshi
      mako
      materia-theme
      mpv
      unstable.papirus-icon-theme
      pavucontrol
      pcmanfm
      libgsf
      ffmpegthumbnailer
      polkit
      polkit_gnome
      slurp
      sway-polkit
      swayidle
      swaylock-effects
      transmission-remote-gtk
      unstable.tofi
      waybar
      wl-clipboard
      wlsunset
      xarchiver
      xdg-utils
      swaybg
      gcolor3
      swappy
      zathura
      materia-kde-theme
      libsForQt5.qtstyleplugin-kvantum
    ];
  };
  fonts.fonts = with pkgs; [
    font-awesome
    jost
    nerdfonts
    noto-fonts-emoji
    source-han-mono
    source-han-sans
    source-sans
    fantasque-sans-mono
    iosevka
  ];
  sound.enable = false;
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    jack.enable = true;
  };
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    gtkUsePortal = true;

  };
  programs.qt5ct.enable = true;
}
