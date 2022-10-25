{ config, pkgs, ... }: {
  config = {
    environment.systemPackages = with pkgs; [
      sshfs
      libimobiledevice
      ifuse
      exfatprogs
      ntfs3g
      android-tools
    ];
    programs.adb.enable = true;
    services = {
      usbmuxd.enable = true;
      gvfs.enable = true;
      devmon.enable = true;
      #udisks2.enable = true;
      udev.packages = [ pkgs.android-udev-rules ];
    };
  };

}
