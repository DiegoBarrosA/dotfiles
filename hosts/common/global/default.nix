{ lib, inputs, outputs, ... }: {
  imports = [ inputs.impermanence.nixosModules.impermanence ./locale.nix ]
    ++ (builtins.attrValues outputs.nixosModules);

  hardware.enableRedistributableFirmware = true;
}
