{ config, pkgs, ... }: {
  consoleLogLevel = 0;
  boot = {
    kernelParams = [
      "quiet"
      "splash"
      "i915.fastboot=1"
      "boot.shell_on_fail"
      "vt.global_cursor_default=0"
      "loglevel=0"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=0"
      "udev.log_priority=0"
      "fbcon=nodefer"
    ];
    plymouth = {
      enable = true;
      themePackages = [ pkgs.plymouth-themes ];
      theme = "loader_2";
    };
    consoleLogLevel = 0;
    initrd.verbose = false;
    initrd.systemd.enable = true;
  };
  console = {
    useXkbConfig = true;
    earlySetup = false;
  };
}
