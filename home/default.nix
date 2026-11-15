{ ... }:

{
  home.stateVersion = "26.05";

  programs.git.enable = true;

  xdg.configFile = {
    "hypr".source = ./dotfiles/hypr;
    "waybar".source = ./dotfiles/waybar;
  };

  home.file.".local/bin/wallpaper-random" = {
    source = ./scripts/wallpaper-random;
    executable = true;
  };
}
