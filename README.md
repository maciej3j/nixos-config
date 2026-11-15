# nixos-config

Flake z konfiguracją NixOS dla dwóch maszyn:

| Host | Sprzęt | Boot |
|---|---|---|
| `nixos-desktop` | GTX 1660 SUPER | BIOS/legacy, GRUB na `/dev/sda` |
| `nixos-laptop` | RTX 2060 | UEFI (do potwierdzenia) |

## Co jest w repo

Wszystkie programy i dotfiles są zadeklarowane w repo — świeża instalacja
odtwarza je w całości.

| Co | Gdzie |
|---|---|
| Programy CLI / dev (neovim, helix, rustup, python, LSP…) | `modules/system/packages.nix` |
| Programy graficzne (Hyprland, waybar, firefox, thunar…) | `modules/desktop/packages.nix` |
| Konfiguracja Hyprlanda, waybara | `home/dotfiles/hypr`, `home/dotfiles/waybar` |
| `~/.zshrc` (starship, zoxide, fzf, zellij) | `home/dotfiles/zshrc` |
| Skrypt `wallpaper-random` | `home/scripts/wallpaper-random` |
| Konfiguracja helix / kitty | `modules/desktop/default.nix` (przez `/etc/xdg`) |

Dotfiles trafiają do `~/.config` i `~/.local/bin` przez home-manager.

## Struktura

```
flake.nix                  # wejścia + definicje hostów
hosts/
  <host>/default.nix       # hostname, GRUB, specyfika maszyny
  <host>/hardware-configuration.nix   # generowany lokalnie (dyski, CPU, moduły)
modules/
  system/                  # sieć, audio, użytkownicy, pakiety CLI
  desktop/                 # Hyprland, SDDM, NVIDIA, pakiety GUI
home/                      # home-manager: dotfiles + skrypty
```

## Codzienna praca

```bash
sudo nixos-rebuild switch --flake .#nixos-desktop   # na desktopie
sudo nixos-rebuild switch --flake .#nixos-laptop    # na laptopie
```

Po zmianie `flake.nix`:

```bash
nix flake update
```

## Instalacja na nowej maszynie

1. Boot z ISO NixOS, połącz się z WiFi.

2. Partycjonowanie + montaż.

   Laptop (UEFI, cały dysk):

   ```bash
   parted /dev/nvme0n1 -- mklabel gpt
   parted /dev/nvme0n1 -- mkpart ESP fat32 1MiB 1GiB
   parted /dev/nvme0n1 -- set 1 esp on
   parted /dev/nvme0n1 -- mkpart root ext4 1GiB 100%
   mkfs.fat -F 32 /dev/nvme0n1p1
   mkfs.ext4 /dev/nvme0n1p2
   mount /dev/nvme0n1p2 /mnt
   mount --mkdir /dev/nvme0n1p1 /mnt/boot
   ```

   Desktop (BIOS/legacy):

   ```bash
   parted /dev/sda -- mklabel msdos
   parted /dev/sda -- mkpart primary ext4 1MiB 100%
   parted /dev/sda -- set 1 boot on
   mkfs.ext4 /dev/sda1
   mount /dev/sda1 /mnt
   ```

3. Sklonuj repo i wygeneruj konfigurację sprzętu:

   ```bash
   nix-shell -p git
   git clone git@github.com:maciej3j/nixos-config.git /mnt/home/niezlykoksu/nixos-config
   nixos-generate-config --root /mnt
   cp /mnt/etc/nixos/hardware-configuration.nix \
      /mnt/home/niezlykoksu/nixos-config/hosts/<host>/hardware-configuration.nix
   ```

   `<host>` to `nixos-desktop` albo `nixos-laptop`. Ten krok jest zawsze
   konieczny po zmianie partycji — plik w repo to tylko snapshot z poprzedniej
   instalacji i zawiera UUID dysku.

4. Sprawdź `hosts/<host>/default.nix` (GRUB: UEFI vs BIOS, ewentualny PRIME)
   i zainstaluj:

   ```bash
   nixos-install --flake /mnt/home/niezlykoksu/nixos-config#<host>
   ```

5. Ustaw hasło użytkownika:

   ```bash
   nixos-enter --root /mnt -c 'passwd niezlykoksu'
   ```

## Różnice per host

| | desktop | laptop |
|---|---|---|
| `networking.hostName` | `nixos-desktop` | `nixos-laptop` |
| GRUB | `device = "/dev/sda"` (BIOS) | `device = "nodev"` + `efiSupport` |
| GPU | GTX 1660 SUPER (open) | RTX 2060 (open) + opcjonalny PRIME |

## Czego repo nie zawiera

Dane osobiste: `~/.ssh`, `~/.rustup`, obrazy Dockera, `~/.config/opencode`
(oraz tapety w `~/Pictures/wallpapers`, jeśli mają być). To nie jest potrzebne
do działania systemu.

## Uwagi

- `hosts/nixos-laptop/hardware-configuration.nix` jest placeholderem z
  assertionem — dopóki nie zostanie wygenerowany na laptopie, budowa tego
  hosta kończy się czytelnym błędem.
- Home-manager przy pierwszej aktywacji robi backup istniejących plików
  w `~/.config` z sufiksem `.hm-backup`.
