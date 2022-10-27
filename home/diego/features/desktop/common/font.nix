{ pkgs, ... }: {
  fontProfiles = {
    enable = true;
    monospace = {
      family = "Fantasque Sans Mono";
      package = pkgs.nerdfonts.override { fonts = [ "fantasque-sans-mono" ]; };
    };
    regular = {
      family = "Jost*";
      package = pkgs.jost;
    };
  };
}
