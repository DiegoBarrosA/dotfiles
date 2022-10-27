{ config, lib, pkgs, ... }:

{
  boot = {
    initrd = {
      availableKernelModules =
        [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
      kernelModules = [ "kvm-amd" ];
    };
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
  hardware.cpu.amd.updateMicrocode = true;
  hardware.i2c.enable = true;
  hardware.openrgb.enable = true;

  nixpkgs.hostPlatform.system = "x86_64-linux";
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
