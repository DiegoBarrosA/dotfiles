{ config, pkgs, ... }: {
  imports = [
    ./apps.nix
    ./devices.nix
    ./emacs.nix
    ./environment.nix
    ./hosts.nix
    ./proaudio.nix
    ./services.nix
    ./sway.nix
    ./terminal.nix
    ./users.nix
  ];
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = false;
  system.autoUpgrade.channel = "https://nixos.org/channels/nixos-22.05";
  boot = {
    kernelParams = [
      "quiet"
      "splash"
      "vga=current"
      "boot.shell_on_fail"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=0"
      "udev.log_priority=0"
    ];
    plymouth = { enable = false; };
    consoleLogLevel = 0;
    initrd.verbose = false;
    loader = {
      systemd-boot = {
        enable = true;
        editor = false;
      };
      timeout = 0;
      efi.efiSysMountPoint = "/boot";
      efi.canTouchEfiVariables = true;
    };
  };
  networking.hostName = "amatista-gris";
  networking.useDHCP = false;
  networking.interfaces.wlp1s0.useDHCP = true;
  networking.wireless.userControlled.enable = true;
  networking.wireless.enable = true;
  time.timeZone = "America/Santiago";
  i18n.defaultLocale = "en_US.UTF-8";
  services.openssh.enable = true;
  security.sudo.wheelNeedsPassword = false;
  # ...
  console = { keyMap = "us"; };
  fileSystems = {
    "/".options = [ "compress=zstd" ];
    "/home".options = [ "compress=zstd" ];
    "/nix".options = [ "compress=zstd" "noatime" ];
  };
  services.tlp.enable = true;
  environment.systemPackages = with pkgs; [ linux-firmware ];
}
