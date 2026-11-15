# Pakiety CLI / narzędzia deweloperskie (bez części graficznej).
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    neovim
    helix
    opencode

    wget
    git
    gh

    basedpyright
    ruff
    ty
    uv
    python314

    rustup
    rust-analyzer

    nixd
    nixfmt

    lua-language-server
    sqls
    marksman
    taplo
    yaml-language-server
    bash-language-server
    vscode-langservers-extracted

    shfmt
    prettierd

    docker-compose

    zellij
    zsh
    starship
    zoxide
    atuin
    fastfetch
    btop
    ripgrep
    fd
    fzf
    unzip
    lazygit
    bat
    eza
    yazi

    bluetui
  ];
}
