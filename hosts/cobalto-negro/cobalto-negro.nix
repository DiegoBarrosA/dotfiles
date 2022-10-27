{ inputs, pkgs, ... }: {
  imports = [
    inputs.hardware.nixosModules.common-cpu-amd
    inputs.hardware.nixosModules.common-gpu-amd
    inputs.hardware.nixosModules.common-pc-ssd
    ../common/global
    ../common/optional/silent-boot.nix
    ./hardware-configuration.nix
  ];
  nixpkgs.overlays = [ (import /etc/nixos/packages) ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = false;
  system.autoUpgrade.channel = "https://nixos.org/channels/nixos-22.05";

  networking = {
    hostName = "cobalto-negro";
    hostId = "8556b001";
    useDHCP = false;
    interfaces.enp5s0.useDHCP = true;
  };
  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;
    binfmt.emulatedSystems = [ "aarch64-linux" ];
  };

  services.openssh.enable = true;
  security.sudo.wheelNeedsPassword = false;
  console = {
    keyMap = "us";
    font = "${pkgs.terminus_font}/share/consolefonts/ter-214n.psf.gz";
    packages = with pkgs; [ terminus_font ];
  };
  virtualisation.libvirtd = { enable = true; };
  environment.systemPackages = with pkgs; [
    virt-manager
    pkgs.linux-firmware
    pkgs.cage
    pkgs.kitty
  ];
  system.stateVersion = "22.05";
}
