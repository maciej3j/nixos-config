# ⚠️  PLACEHOLDER — NIE UŻYWAJ TEGO PLIKU DO INSTALACJI  ⚠️
#
# Ten plik trzeba wygenerować na laptopie (z live ISO NixOS), bo zawiera
# identyfikatory dysków, moduły jądra i ustawienia CPU konkretnej maszyny.
#
#   nixos-generate-config --root /mnt --show-hardware-config \
#     > /mnt/home/niezlykoksu/nixos-config/hosts/nixos-laptop/hardware-configuration.nix
#
# albo po prostu skopiuj /mnt/etc/nixos/hardware-configuration.nix w to miejsce.
#
# Dopóki to nie zostanie zrobione, budowanie hosta `nixos-laptop` kończy się
# błędem (assertion poniżej) — celowo, żeby nie zainstalować systemu z
# nieprawidłową konfiguracją dysku.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  assertions = [
    {
      assertion = config.fileSystems."/".device != "/dev/disk/by-uuid/REPLACE-ME";
      message = ''
        hosts/nixos-laptop/hardware-configuration.nix jest placeholderem.
        Wygeneruj go na laptopie:
          nixos-generate-config --root /mnt --show-hardware-config > hosts/nixos-laptop/hardware-configuration.nix
      '';
    }
  ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/REPLACE-ME";
    fsType = "ext4";
  };

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
