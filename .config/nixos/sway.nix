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


    '';
  };

in {
  qt5.style = "gtk2";
  qt5.enable = true;
  qt5.platformTheme = "gtk2";
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command =
          "${pkgs.greetd.tuigreet}/bin/tuigreet --remember --greeting 'God is dead' --time --cmd sway  --sessions ${pkgs.i3}/share/applications/i3.desktop";
        user = "greeter";
      };
    };
  };
  security.pam.services.greetd.enableGnomeKeyring = true;
  environment.etc = {
    "greetd/environments".text = ''
      sway
      fish
    '';
  };
  security.polkit.enable = true;
  services.xserver.windowManager.i3.enable = true;
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraSessionCommands = ''
                        export SDL_VIDEODRIVER=wayland
                        export QT_QPA_PLATFORM=wayland-egl
                        export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
                        export GTK_USE_PORTAL=1
                  export QT_WAYLAND_FORCE_DPI=physical
                  export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
            export BROWSER=firefox
            export TERM=alacritty
      export _JAVA_AWT_WM_NONREPARENTING=1
      export NO_AT_BRIDGE=1
    '';
    extraPackages = with pkgs; [
      alacritty
      autotiling
      capitaine-cursors
      clipman
      configure-gtk
      dbus-sway-environment
      firefox-wayland
      glib
      greetd.gtkgreet
      grim
      imv
      kanshi
      mako
      materia-theme
      mpv
      ario
      papirus-icon-theme
      pavucontrol
      pcmanfm
      polkit
      polkit_gnome
      slurp
      sway-polkit
      swaybg
      swayidle
      swaylock-effects
      thunderbird-wayland
      transmission-remote-gtk
      unstable.tofi
      waybar
      wayland
      wl-clipboard
      wlsunset
      wofi
      xarchiver
      xdg-utils
      zathura
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
  };

}
