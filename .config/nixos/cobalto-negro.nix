{ config, pkgs, ... }: {
  imports = [
    ./apps.nix
    ./devices.nix
    ./environment.nix
    ./gaming.nix
    ./hosts.nix
    ./proaudio.nix
    ./services.nix
    ./sway.nix
    ./terminal.nix
    ./users.nix
    ./virtmanager.nix
    ./emacs.nix
  ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = false;
  system.autoUpgrade.channel = "https://nixos.org/channels/nixos-22.05";
  boot = {
    kernelParams = [
      "quiet"
      "splash"
      "amdgpu"
      "boot.shell_on_fail"
      "vt.global_cursor_default=0"
      "loglevel=0"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=0"
      "udev.log_priority=0"
    ];
    plymouth = {

      enable = true;
    };
    consoleLogLevel = 0;
    initrd.verbose = false;

    initrd.systemd.enable = true;
    loader = {
      systemd-boot = {
        enable = true;
        editor = false;
        graceful = true;
      };
      timeout = 0;
      efi.efiSysMountPoint = "/boot/efi";
      efi.canTouchEfiVariables = true;
    };
  };
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.extraPackages = with pkgs; [
    amdvlk
    rocm-opencl-icd
    rocm-opencl-runtime
  ];
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 443 ];
    allowedUDPPortRanges = [
      {
        from = 4000;
        to = 4007;
      }
      {
        from = 8000;
        to = 8090;
      }
    ];
  };
  networking.hostName = "cobalto-negro";
  networking.hostId = "8556b001";
  networking.useDHCP = false;
  networking.interfaces.enp5s0.useDHCP = true;
  time.timeZone = "America/Santiago";
  i18n.defaultLocale = "en_US.UTF-8";
  services.openssh.enable = true;
  security.sudo.wheelNeedsPassword = false;
  console = { keyMap = "us"; };
  hardware.i2c.enable = true;
  environment.systemPackages = [ pkgs.linux-firmware ];
  fileSystems = {
    "/".options = [ "compress=zstd" ];
    "/home".options = [ "compress=zstd" ];
    "/nix".options = [ "compress=zstd" "noatime" ];

    "/swap".options = [ "noatime" ];

    "/storage/var".options = [ "compress=zstd" ];

    "/storage/home".options = [ "compress=zstd" ];

    "/storage/share".options = [ "compress=zstd" ];
  };
  swapDevices = [{ device = "/swap/swapfile"; }];
}
