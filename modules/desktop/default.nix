# Warstwa graficzna: Hyprland + SDDM (wspólna dla wszystkich hostów).
{ pkgs, ... }:

{
  imports = [
    ./nvidia.nix
    ./packages.nix
  ];

  services.xserver.xkb = {
    layout = "pl";
    variant = "";
  };

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
  };

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    package = pkgs.kdePackages.sddm;
    theme = "catppuccin-mocha-mauve";
    settings.Autologin = {
      Session = "hyprland-uwsm.desktop";
      User = "niezlykoksu";
    };
  };

  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];

  environment.sessionVariables = {
    GTK_THEME = "catppuccin-mocha-mauve-standard";
  };

  environment.etc."xdg/helix/config.toml".text = ''
    theme = "catppuccin_mocha"

    [editor]
    line-number = "relative"
    mouse = true
    scrolloff = 8
    bufferline = "multiple"
    color-modes = true
    true-color = true
    auto-format = true
    cursorline = true
    rulers = [100]
    end-of-line-diagnostics = "hint"

    [editor.cursor-shape]
    insert = "block"
    normal = "block"
    select = "underline"

    [editor.indent-guides]
    render = true
    character = "┊"
    skip-levels = 1

    [editor.lsp]
    display-messages = true
    display-inlay-hints = true
    auto-signature-help = true
    auto-document-highlight = true
    snippets = true

    [editor.inline-diagnostics]
    cursor-line = "warning"
    other-lines = "error"
    prefix-len = 2
    max-wrap = 20
    max-diagnostics = 5

    [editor.file-picker]
    hidden = false
    git-ignore = true

    [editor.statusline]
    left = ["mode", "spinner", "file-name", "file-modification-indicator"]
    center = ["version-control"]
    right = ["diagnostics", "selections", "position", "file-encoding", "file-line-ending", "file-type"]
    separator = "|"
  '';

  environment.etc."xdg/helix/languages.toml".text = ''
    [language-server.basedpyright]
    command = "basedpyright-langserver"
    args = ["--stdio"]

    [language-server.ruff]
    command = "ruff"
    args = ["server"]

    [language-server.rust-analyzer]
    command = "rust-analyzer"

    [language-server.nixd]
    command = "nixd"

    [language-server.lua-language-server]
    command = "lua-language-server"

    [language-server.dockerfile-language-server]
    command = "docker-langserver"
    args = ["--stdio"]

    [language-server.taplo]
    command = "taplo"
    args = ["lsp", "stdio"]

    [language-server.vscode-json-language-server]
    command = "vscode-json-language-server"
    args = ["--stdio"]

    [language-server.vscode-html-language-server]
    command = "vscode-html-language-server"
    args = ["--stdio"]

    [language-server.vscode-css-language-server]
    command = "vscode-css-language-server"
    args = ["--stdio"]

    [language-server.sqls]
    command = "sqls"

    [language-server.yaml-language-server]
    command = "yaml-language-server"
    args = ["--stdio"]

    [language-server.bash-language-server]
    command = "bash-language-server"
    args = ["start"]

    [language-server.marksman]
    command = "marksman"
    args = ["server"]

    [[language]]
    name = "python"
    language-servers = ["basedpyright", "ruff"]
    auto-format = true

    [[language]]
    name = "rust"
    language-servers = ["rust-analyzer"]
    formatter = { command = "rustfmt" }
    auto-format = true

    [[language]]
    name = "nix"
    language-servers = ["nixd"]
    formatter = { command = "nixfmt" }
    auto-format = true

    [[language]]
    name = "lua"
    language-servers = ["lua-language-server"]
    auto-format = true

    [[language]]
    name = "dockerfile"
    language-servers = ["dockerfile-language-server"]
    auto-format = true

    [[language]]
    name = "toml"
    language-servers = ["taplo"]
    auto-format = true

    [[language]]
    name = "json"
    language-servers = ["vscode-json-language-server"]
    auto-format = true

    [[language]]
    name = "jsonc"
    language-servers = ["vscode-json-language-server"]
    auto-format = true

    [[language]]
    name = "sql"
    language-servers = ["sqls"]
    auto-format = true

    [[language]]
    name = "html"
    language-servers = ["vscode-html-language-server"]
    auto-format = true

    [[language]]
    name = "css"
    language-servers = ["vscode-css-language-server"]
    auto-format = true

    [[language]]
    name = "yaml"
    language-servers = ["yaml-language-server"]
    auto-format = true

    [[language]]
    name = "bash"
    language-servers = ["bash-language-server"]
    formatter = { command = "shfmt", args = ["-i", "2"] }
    auto-format = true

    [[language]]
    name = "markdown"
    language-servers = ["marksman"]
    auto-format = true
  '';

  environment.etc."xdg/kitty/kitty.conf".text = ''
    font_family JetBrainsMono Nerd Font
    font_size 15

    background #1e1e2e
    foreground #cdd6f4
    selection_background #585b70
    selection_foreground #cdd6f4
    cursor #f5e0dc
    cursor_text_color #1e1e2e

    color0 #45475a
    color1 #f38ba8
    color2 #a6e3a1
    color3 #f9e2af
    color4 #89b4fa
    color5 #f5c2e7
    color6 #94e2d5
    color7 #bac2de
    color8 #585b70
    color9 #f38ba8
    color10 #a6e3a1
    color11 #f9e2af
    color12 #89b4fa
    color13 #f5c2e7
    color14 #94e2d5
    color15 #a6adc8

    background_opacity 0.92
    window_padding_width 10
    hide_window_decorations yes
    confirm_os_window_close 0

    cursor_shape block
    cursor_blink_interval 0

    repaint_delay 10
    input_delay 3
    sync_to_monitor yes

    scrollback_lines 10000
    wheel_scroll_multiplier 5.0

    clipboard_control write-clipboard write-primary
    copy_on_select clipboard

    enable_audio_bell no
    visual_bell_duration 0

    disable_ligatures never
    mouse_hide_wait 3.0
    url_style curly
    update_check_interval 0
  '';
}
