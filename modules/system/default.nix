# Ustawienia wspólne dla wszystkich hostów.
{ pkgs, lib, ... }:

{
  imports = [
    ./packages.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config.allowUnfree = true;

  boot.loader.grub = {
    enable = true;
    useOSProber = true;
  };

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Warsaw";

  i18n = {
    defaultLocale = "pl_PL.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "pl_PL.UTF-8";
      LC_IDENTIFICATION = "pl_PL.UTF-8";
      LC_MEASUREMENT = "pl_PL.UTF-8";
      LC_MONETARY = "pl_PL.UTF-8";
      LC_NAME = "pl_PL.UTF-8";
      LC_NUMERIC = "pl_PL.UTF-8";
      LC_PAPER = "pl_PL.UTF-8";
      LC_TELEPHONE = "pl_PL.UTF-8";
      LC_TIME = "pl_PL.UTF-8";
    };
  };

  console.keyMap = "pl2";

  hardware.bluetooth.enable = true;

  services = {
    dbus.enable = true;
    blueman.enable = true;
    gvfs.enable = true;
    tumbler.enable = true;
    openssh.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  programs.dconf.enable = true;

  virtualisation.docker.enable = true;

  users.users.niezlykoksu = {
    isNormalUser = true;
    description = "niezlykoksu";
    extraGroups = [
      "networkmanager"
      "wheel"
      "input"
      "docker"
    ];
    shell = pkgs.zsh;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    interactiveShellInit = ''
      export PATH="$HOME/.cargo/bin:$PATH"
    '';
    shellAliases = {
      ls = "eza --header --icons --group-directories-first";
      ll = "eza -lah --icons --header --group-directories-first";
      la = "eza --header --icons -a";
      tree = "eza --tree --icons --header";
      cat = "bat";
      helix = "hx";
    };
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    font-awesome
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
  ];

  system.stateVersion = "26.05";
}
