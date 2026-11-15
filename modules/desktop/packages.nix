# Pakiety graficzne / waylandowe.
{ pkgs, wlctl, ... }:

{
  environment.systemPackages = with pkgs; [
    (catppuccin-sddm.override {
      flavor = "mocha";
      accent = "mauve";
      clockEnabled = true;
    })

    wlctl.packages.${pkgs.stdenv.hostPlatform.system}.default

    kitty
    xfconf

    catppuccin-gtk
    papirus-icon-theme
    adwaita-icon-theme

    hyprlock
    hyprsunset
    hyprpolkitagent
    hyprlauncher
    hyprpaper

    waybar
    wlogout
    mako
    grim
    slurp
    wl-clipboard
    swappy
    cliphist
    brightnessctl
    playerctl

    pavucontrol
    networkmanagerapplet
    blueman

    firefox
    loupe
    file-roller
    thunar
    wofi
    xdg-utils
  ];
}
