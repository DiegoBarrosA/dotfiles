{ pkgs, ... }: {
  imports = [
    ./gammastep.nix
    ./kitty.nix
    ./mako.nix
    ./qutebrowser.nix
    ./swayidle.nix
    ./swaylock.nix
    ./waybar.nix
    ./wofi.nix
    ./zathura.nix
  ];

  home.packages = with pkgs; [
    qt5.qtwayland
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
    papirus-icon-theme
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

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = true;
    QT_QPA_PLATFORM = "wayland";
    LIBSEAT_BACKEND = "logind";
  };
}
