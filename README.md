# Hyprland Rice

A complete setup for a customized and modern Wayland desktop experience using **[Hyprland](https://github.com/hyprwm/Hyprland)**.

![fastest window](SS.PNG)

## Disclaimer

This repository exists mainly as a backup of my personal Linux desktop setup. Feel free to use it as inspiration or a starting point, but keep in mind that it's tailored to my workflow and environment. If something breaks on your system, you're on your own.

I don't own or claim authorship of the software, artwork, wallpapers, Fonts, or other third-party resources used here. All credit goes to their respective creators. I only wrote the configuration files and custom scripts that make this setup work for me.

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

- **Font:** [FiraCode](https://github.com/tonsky/FiraCode), [OCRA](https://fontsgeek.com/fonts/OCRA-Regular)  
  Install in: `~/.fonts`

- **Wallpaper:** [epic-cat](https://wall.alphacoders.com/big.php?i=103573)
  Place in: `~/.config/hypr/` and rename to `epic-cat.jpg`

---

## ⚙️ Required Packages

### Used in Configs 
- [hyprland](https://github.com/hyprwm/Hyprland) — window manager
- [hypridle](https://github.com/hyprwm/hypridle) — idle manager  
- [hyprlock](https://github.com/hyprwm/hyprlock) — Lock screen utility
- [hypr-zoom](https://github.com/FShou/hypr-zoom) — zoom on hyprland
- [xdg-desktop-portal-hyprland](https://github.com/hyprwm/xdg-desktop-portal-hyprland) — Desktop portal backend for Wayland  
- [ghostty](https://github.com/ghostty-org/ghostty), [foot](https://codeberg.org/dnkl/foot) — Terminal emulators  
- [waybar](https://github.com/Alexays/Waybar) — Status bar  
- [gtk3](https://docs.gtk.org/gtk3/), [gtk4](https://docs.gtk.org/gtk4/) — GTK toolkits  
- [qt5ct](https://sourceforge.net/projects/qt5ct/), [qt6ct](https://github.com/trialuser02/qt6ct) — Set qt theme
- [mako](https://github.com/emersion/mako) — Notification daemon  
- [swaybg](https://github.com/swaywm/swaybg) — Wallpaper/background manager  
- [polkit-gnome](https://gitlab.gnome.org/Archive/policykit-gnome) — PolicyKit authentication agent  
- [rofi](https://github.com/davatorium/rofi) — App launcher (run menu)  
- [playerctl](https://github.com/altdesktop/playerctl) — Media control (MPRIS)
- [chromium](https://github.com/chromium/chromium), [librewolf](https://librewolf.net/) — Web browsers  
- [thunar](https://github.com/neilbrown/thunar), [superfile](https://github.com/yorukot/superfile) — GUI and TUI File managers  
- cpupower — CPU power management  
- [btop](https://github.com/aristocratos/btop) — System monitor  
- [networkmanager](https://gitlab.freedesktop.org/NetworkManager/NetworkManager) — Network control (with nmtui)  
- [pavucontrol](https://gitlab.freedesktop.org/pulseaudio/pavucontrol), [pipewire](https://github.com/PipeWire/pipewire), [wireplumber](https://github.com/PipeWire/wireplumber) — Audio stack for Wayland
- [screen shot and record scrips](https://github.com/DASH-666/screen-record-and-shot-script-for-hyprland) — to get screen shot and screen record
- [easyeffects](https://github.com/wwmm/easyeffects) — Audio effects over PipeWire  
- [mpd](https://github.com/MusicPlayerDaemon/MPD), [rmpc](https://github.com/mierak/rmpc), [mpc](https://github.com/MusicPlayerDaemon/mpc) — Music player with MPRIS support  
- [hyprmon](https://github.com/erans/hyprmon) — Display output managment
- [librewolf](https://librewolf.net/) — Browser
- [dynamic-cursors](https://github.com/VirtCode/hypr-dynamic-cursors) — This plugin makes your cursor more realistic
- [hyprexpo-plus](https://github.com/sandwichfarm/hyprexpo-plus) — HyprExpo+ is a fork of [HyprExpo](https://github.com/hyprwm/hyprland-plugins/tree/main/hyprexpo) that adds additional functionality
- [wayscriber](https://github.com/devmobasa/wayscriber) — A ZoomIt-like real-time screen annotation tool for Linux/Wayland, written in Rust

---

## 💡 Optional Packages (Recommended)  

- [cava](https://github.com/karlstav/cava), [waybar-cava](https://github.com/Alexays/Waybar) — Audio visualizer for Waybar(optioanl) 
- [zsh](https://www.zsh.org/), [oh-my-zsh](https://ohmyz.sh/) — Zsh is a shell designed for interactive use
- [neovim](https://neovim.io/) — hyperextensible Vim-based text editor
- [wev](https://github.com/jwrdegoede/wev) — Key-code finder for add custom keybinds(optional)  
- [scrcpy](https://github.com/Genymobile/scrcpy) — Display Android screen on PC(optional)

---
## 🔐 CPU Power Control Fix

To allow cpupower commands to run without a sudo password prompt:
```
sudo visudo
```

Then add this line (replace your_username with your actual username):
```
your_username ALL=(ALL) NOPASSWD: /usr/bin/cpupower
```
## 🛠️ Installation Steps  
1. Install all required dependencies listed above.
recuired:
```
sudo pacman -Syu hyprland hypridle hyprlock hypr-zoom xdg-desktop-portal-hyprland ghostty foot waybar gtk3 gtk4 mako swaybg polkit-gnome rofi playerctl chromium thunar superfile btop pavucontrol pipewire wireplumber pipewire-pulse easyeffects mpd rmpc mpc
yay -S librewolf-bin hyprmon-bin 


sudo pacman -Syu zsh neovim wev scrcpy cava # (optional)
yay -S waybar-cava oh-my-zsh-git # (optional)
```

2. Install plugins:
```
hyprpm add https://github.com/sandwichfarm/hyprexpo-plus
hyprpm enable hyprexpo-plus
hyprpm add https://github.com/virtcode/hypr-dynamic-cursors
hyprpm enable dynamic-cursors
```
3. Copy themes, icons, fonts, and wallpaper into their respective directories.  
4. Copy configuration folders into `~/.config/`:
5. Reboot your machine.  
6. Select **Hyprland** in your session manager, or run from TTY:  `start-hyprland`
7. see `~/.config/hypr/hyprland.conf` for keybinds and enjoy :D
