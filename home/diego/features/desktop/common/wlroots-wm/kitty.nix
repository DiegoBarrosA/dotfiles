{ config, pkgs, ... }:

let
  kitty-xterm = pkgs.writeShellScriptBin "xterm" ''
    ${config.programs.kitty.package}/bin/kitty -1 "$@"
  '';
in {
  home = {
    packages = [ kitty-xterm ];
    preferredApps.terminal = {
      cmd = "kitty -1";
      cmd-spawn = program: "kitty -1 $SHELL -i -c ${program}";
    };
    sessionVariables = { TERMINAL = "kitty"; };
  };
  programs.kitty = {
    enable = true;
    font = {
      name = config.fontProfiles.monospace.family;
      size = 15;
    };
    settings = { window_padding_width = 15; };
  };
}
