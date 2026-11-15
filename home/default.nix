{ ... }:

{
  home.stateVersion = "26.05";

  programs.git = {
    enable = true;
    settings.user = {
      name = "maciej3j";
      email = "97947775+maciej3j@users.noreply.github.com";
    };
  };

  xdg.configFile = {
    "hypr".source = ./dotfiles/hypr;
    "waybar".source = ./dotfiles/waybar;
  };

  home.file = {
    ".zshrc".source = ./dotfiles/zshrc;

    ".local/bin/wallpaper-random" = {
      source = ./scripts/wallpaper-random;
      executable = true;
    };
  };
}
