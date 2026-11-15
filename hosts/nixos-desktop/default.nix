{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system
    ../../modules/desktop
  ];

  networking.hostName = "nixos-desktop";

  # Dysk BIOS/legacy (MBR) — obecny komputer bootuje przez GRUB z /dev/sda.
  boot.loader.grub.device = "/dev/sda";
}
