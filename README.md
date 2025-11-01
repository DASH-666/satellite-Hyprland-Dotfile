# Hyprland Rice

A complete setup for a customized and modern Wayland desktop experience using **Hyprland**.

---

## 🎨 Themes and Customizations

| Type          | Name                   | Install Path        | Download Link |
|---------------|------------------------|---------------------|---------------|
| GTK Theme     | Adwaita Dark Amoled    | `~/.themes`         | https://www.gnome-look.org/p/1553851 |
| Cursor Theme  | Bibata Modern Classic  | `~/.icons`          | https://www.gnome-look.org/p/1914825 |
| QT Theme      | Adwaita Dark           | `~/.themes`         | https://www.gnome-look.org/p/1014995/ |
| Icon Theme    | BeautyLine             | `~/.icons`          | https://www.gnome-look.org/p/1425426 |
| Font          | FiraCode               | `~/.fonts`          | https://github.com/tonsky/FiraCode |
| Wallpaper     | Spaceship              | `~/.config/waybar/` (as `spaceship.jpg`) | https://www.vecteezy.com/photo/29163762-3d-cg-rendering-of-space-ship |

---

## ⚙️ Required Packages

### Core Components

| Package                         | Description                       |
|----------------------------------|-----------------------------------|
| `hyprland`                       | Window Manager (WM)               |
| `hypridle`                       | Idle manager for Hyprland         |
| `hyprlock`                       | Lock screen utility               |
| `xdg-desktop-portal-hyprland`    | Desktop portal backend (Wayland)  |
| `libinput`                       | Input devices support             |

### Used in Configs

| Package        | Purpose                          |
|----------------|----------------------------------|
| `ghostty`, `foot` | Terminal emulator              |
| `waybar`       | Status bar                       |
| `gtk3`, `gtk4` | Graphics backend                 |
| `mako`         | Notification daemon              |
| `swaybg`       | Wallpaper/background manager     |
| `polkit-gnome` | PolicyKit authentication agent   |
| `rofi`         | App launcher (run menu)          |
| `zenity`, `slurp`, `grim` | Screenshot utilities  |
| `playerctl`    | Media control (MPRIS)            |
| `chromium`, `firefox` | Web browsers              |
| `thunar`, `yazi`      | File managers              |
| `cava` + `waybar-cava` | Audio visualizer          |
| `cpupower`     | CPU power management             |
| `btop`         | System monitor                   |
| `networkmanager` | Network configuration tools   |
| `pavucontrol`, `pipewire`, `wireplumber` | Audio stack for Wayland |

---

## 💡 Optional Packages (Recommended)

| Package        | Purpose                           |
|----------------|-----------------------------------|
| `easyeffects`  | Audio effects on Pipewire         |
| `mpd`, `ncmpcpp`, `mpd-mpris` | Music playing setup |
| `wev`          | Keycode finder for keybind setup  |
| `scrcpy`       | Display Android screen on PC      |
| `ghostty`      | Fast and modern terminal          |

---

## 🛠️ Installation Steps

1. Install all dependencies listed above.
2. Copy themes, icons, fonts, and wallpaper to their respective paths.
3. Place the `hypr/`, `waybar/`, `mako/`, `rofi/` directories into `~/.config/`.
4. Reboot your PC.
5. Start Hyprland from your session manager, or run this on TTY:

   ```bash
   Hyprland
