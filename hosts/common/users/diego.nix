{ pkgs, config, lib, outputs, ... }:
let
  ifTheyExist = groups:
    builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  users.mutableUsers = false;
  users.users.diego = {
    isNormalUser = true;
    shell = pkgs.fish;
    description = "Diego Barros";
    extraGroups = [ "wheel" "video" "audio" "storage" ] ++ ifTheyExist [
      "adbusers"
      "input"
      "network"
      "i2c"
      "git"
      "libvirtd"
      "transmission"
      "camera"
    ];
  };

  security.pam.services = { swaylock = { }; };
}
