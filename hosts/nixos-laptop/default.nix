{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system
    ../../modules/desktop
  ];

  networking.hostName = "nixos-laptop";

  # Zakładamy boot UEFI (typowe dla laptopa). Jeśli laptop jest w trybie
  # BIOS/legacy, usuń `efiSupport`/`efiInstallAsRemovable` i ustaw:
  #   boot.loader.grub.device = "/dev/nvme0n1";   # albo /dev/sda
  boot.loader.grub = {
    device = "nodev";
    efiSupport = true;
    efiInstallAsRemovable = false;
  };

  # Jeśli laptop ma hybrydową grafikę (iGPU Intel/AMD + NVIDIA), odkomentuj
  # i popraw numery PCI (sprawdź `lspci | grep -E 'VGA|3D'`):
  #
  # hardware.nvidia.prime = {
  #   offload.enable = true;
  #   intelBusId = "PCI:0:2:0";
  #   nvidiaBusId = "PCI:1:0:0";
  # };
}
