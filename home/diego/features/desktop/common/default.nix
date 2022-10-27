{ pkgs, lib, outputs, ... }: {
  imports = [ ./font.nix ./gtk.nix ];

  xdg.mimeApps.enable = true;
  home.packages = with pkgs; [ xdg-utils-spawn-terminal ];
}
