# Hyprland Rice

A complete setup for a customized and modern Wayland desktop experience using **[Hyprland](https://github.com/hyprwm/Hyprland)**.

---

## 🎨 Themes and Customizations

- **GTK Theme:** [Adwaita Dark Amoled](https://www.gnome-look.org/p/1553851)  
  Install in: `~/.themes`

- **Cursor Theme:** [Bibata Modern Classic](https://www.gnome-look.org/p/1914825)  
  Install in: `~/.icons`

- **QT Theme:** [Adwaita Dark](https://www.gnome-look.org/p/1014995/)  
  Install in: `~/.themes`

- **Icon Theme:** [BeautyLine](https://github.com/gvolpe/BeautyLine)  
  Install in: `~/.icons`

- **Font:** [FiraCode](https://github.com/tonsky/FiraCode)  
  Install in: `~/.fonts`

- **Wallpaper:** Spaceship — download image from [here](https://www.vecteezy.com/photo/29163762-3d-cg-rendering-of-space-ship)  
  Place in `~/.config/hypr/` and rename to `spaceship.jpg`

---

## ⚙️ Required Packages

### Core Components  
- [Hyprland](https://github.com/hyprwm/Hyprland) — window manager
- [Hypridle](https://github.com/hyprwm/hypridle) — idle manager  
- [Hyprlock](https://github.com/hyprwm/hyprlock) — Lock screen utility  
- [xdg-desktop-portal-hyprland](https://github.com/hyprwm/xdg-desktop-portal-hyprland) — Desktop portal backend for Wayland  
- [libinput](https://github.com/wayland-tablet/libinput) — Input device support  

### Used in Configs  
- ghostty, foot — Terminal emulators  
- waybar — Status bar  
- gtk3, gtk4 — GTK toolkits  
- mako — Notification daemon  
- swaybg — Wallpaper/background manager  
- polkit-gnome — PolicyKit authentication agent  
- rofi — App launcher (run menu)  
- zenity, slurp, grim — Screenshot utilities  
- playerctl — Media control (MPRIS)  
- chromium, firefox — Web browsers  
- thunar, yazi — File managers  
- cava + waybar-cava — Audio visualizer for Waybar  
- cpupower — CPU power management  
- btop — System monitor  
- networkmanager — Network control (with nmtui)  
- pavucontrol, pipewire, wireplumber — Audio stack for Wayland  

---

## 💡 Optional Packages (Recommended)  
- easyeffects — Audio effects over PipeWire  
- mpd, rmpc, mpd-mpris — Music player with MPRIS support  
- wev — Key-code finder for custom keybinds  
- scrcpy — Display Android screen on PC  
- ghostty — Highly recommended terminal emulator  

---

## 🛠️ Installation Steps  
1. Install all required dependencies listed above.  
2. Copy themes, icons, fonts, and wallpaper into their respective directories.  
3. Copy configuration folders into `~/.config/`:  
