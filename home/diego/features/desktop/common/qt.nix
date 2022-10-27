{ pkgs, ... }: {
  programs.qt5ct.enable = true;
  home.packages = with pkgs; [ materia-kde-theme ];
}
