# nixos-config

Flake z konfiguracją NixOS dla dwóch maszyn:

| Host | Sprzęt | Boot |
|---|---|---|
| `nixos-desktop` | GTX 1660 SUPER | BIOS/legacy, GRUB na `/dev/sda` |
| `nixos-laptop` | RTX 2060 | UEFI (do potwierdzenia) |

## Struktura

```
flake.nix                  # wejścia + definicje hostów
hosts/
  <host>/default.nix       # rzeczy specyficzne dla maszyny (hostname, GRUB, GPU)
  <host>/hardware-configuration.nix   # WYGENEROWANY lokalnie, nie współdzielony
modules/
  system/                  # wspólne: sieć, audio, użytkownicy, pakiety CLI
  desktop/                 # wspólne: Hyprland, SDDM, NVIDIA, pakiety GUI
home/                      # home-manager: dotfiles (hypr, waybar) + skrypty
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

## Instalacja na nowej maszynie (laptop)

1. Boot z ISO NixOS, połącz się z WiFi.
2. Partycjonowanie + montaż (przykład dla UEFI, cały dysk):

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

3. Sklonuj repo i wygeneruj konfigurację sprzętu:

   ```bash
   nix-shell -p git
   git clone git@github.com:maciej3j/nixos-config.git /mnt/home/niezlykoksu/nixos-config
   nixos-generate-config --root /mnt
   cp /mnt/etc/nixos/hardware-configuration.nix \
      /mnt/home/niezlykoksu/nixos-config/hosts/nixos-laptop/hardware-configuration.nix
   ```

4. Sprawdź `hosts/nixos-laptop/default.nix` (GRUB: UEFI vs BIOS, ewentualny PRIME)
   i zainstaluj:

   ```bash
   nixos-install --flake /mnt/home/niezlykoksu/nixos-config#nixos-laptop
   ```

5. Po restarcie ustaw hasło, jeśli trzeba: `passwd niezlykoksu`.

## Odtworzenie desktopa od zera

Obecny układ: MBR (`dos`), BIOS/legacy, GRUB w MBR `/dev/sda`,
`/` = ext4 o UUID `0932b15a-dc7e-42cb-a4bd-495914ab1505`.
`hardware-configuration.nix` wskazuje root po UUID, więc **nowy dysk musi dostać
ten sam UUID** — inaczej system nie wstanie. Alternatywa: po `mkfs` uruchomić
`nixos-generate-config --root /mnt` i podmienić plik w `hosts/nixos-desktop/`.

```bash
# live ISO w trybie BIOS/legacy
parted /dev/sda -- mklabel msdos
parted /dev/sda -- mkpart primary ext4 1MiB 100%
parted /dev/sda -- set 1 boot on
mkfs.ext4 -U 0932b15a-dc7e-42cb-a4bd-495914ab1505 /dev/sda1
mount /dev/sda1 /mnt

nix-shell -p git
git clone git@github.com:maciej3j/nixos-config.git /mnt/home/niezlykoksu/nixos-config
nixos-install --flake /mnt/home/niezlykoksu/nixos-config#nixos-desktop

# hasło użytkownika
nixos-enter --root /mnt -c 'passwd niezlykoksu'
```

Jeśli instalujesz na innym dysku (np. `/dev/nvme0n1`), zmień
`boot.loader.grub.device` w `hosts/nixos-desktop/default.nix`.

## Czego repo nie zawiera (dane osobiste)

System odtworzy się 1:1, ale te rzeczy trzeba skopiować osobno:

- `~/.ssh` (klucze), `~/.config/opencode`, `~/.config/{btop,lazygit,zellij,Thunar,xfce4}`
- `~/Pictures/wallpapers` (ok. 780 MB; `hyprpaper.conf` ma zaszyty `$HOME/...`)
- `~/.rustup` (toolchainy instalowane przez `rustup`, ok. 1.6 GB)
- obrazy Dockera (`docker save`/`load`)

Git identity nie jest ustawiona globalnie — po reinstalacji dodaj
`~/.config/git/config` z `user.name`/`user.email`.

## Uwagi

- `hosts/nixos-laptop/hardware-configuration.nix` jest placeholderem z assertionem —
  dopóki nie zostanie wygenerowany na laptopie, budowa tego hosta kończy się błędem.
- Tapety: `~/Pictures/wallpapers/catppuccin-mocha` (skrypt `wallpaper-random`
  wykrywa monitor automatycznie).
- Home-manager przy pierwszej aktywacji robi backup istniejących plików
  w `~/.config` z sufiksem `.hm-backup`.
