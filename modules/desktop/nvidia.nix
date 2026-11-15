# Sterownik NVIDIA — wspólny dla desktopa (GTX 1660 SUPER) i laptopa (RTX 2060).
# Oba układy to Turing, więc otwarty moduł jądra (open = true) jest wspierany.
{ ... }:

{
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.graphics.enable = true;

  hardware.nvidia = {
    open = true;
    modesetting.enable = true;
    powerManagement.enable = true;
  };
}
