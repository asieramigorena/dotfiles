# dotfiles

Personal Manjaro Linux environment backup. Built around **i3**, **polybar**, **kitty**, and **zsh**.

Two installers are available depending on your use case:

| Script | Use case | Works on |
|---|---|---|
| `install.sh` | Full environment (i3, polybar, kitty, rofi, …) | Arch / Manjaro |
| `install-terminal.sh` | Terminal only (zsh, oh-my-zsh, powerlevel10k) | Debian / Ubuntu / Arch / Manjaro |

---

## Full install (Arch / Manjaro)

```bash
git clone <your-remote-url> ~/.dotfiles
cd ~/.dotfiles
bash install.sh
```

The script will:
1. Symlink every tracked file to its correct location in `$HOME` (existing files are backed up as `.bak`)
2. Install **oh-my-zsh** if not present
3. Clone the required zsh plugins and theme

---

## Terminal-only install (any distro)

Use this when you just want your shell to feel like home — no X11 or desktop environment required. Works on Debian/Ubuntu and Arch/Manjaro. No clone needed; the script fetches only the files it needs.

```bash
curl -fsSL https://raw.githubusercontent.com/asieramigorena/dotfiles/main/install-terminal.sh | bash
```

The script will:
1. Install `zsh`, `git`, and `curl` via the system package manager (`apt` or `pacman`)
2. Install **oh-my-zsh**, **powerlevel10k**, **zsh-autosuggestions**, and **zsh-autocomplete**
3. Download `.zshrc`, `.bashrc`, `.bash_profile`, `.p10k.zsh`, `.dir_colors`, and `.nanorc` directly into `$HOME`
4. Set zsh as the default shell

Log out and back in (or run `exec zsh`) after it finishes.

---

## What gets installed

### Shell — zsh + oh-my-zsh

| Component | Detail |
|---|---|
| Theme | [Powerlevel10k](https://github.com/romkatv/powerlevel10k) — instant prompt, git status, exit codes, command timing |
| `git` | Built-in oh-my-zsh plugin — git aliases (`gst`, `gco`, `gp`, …) |
| `zsh-autosuggestions` | Fish-style inline suggestions from history |
| `zsh-autocomplete` | Real-time completion menu as you type |

Config: `.zshrc`, `.p10k.zsh`

---

### Window manager — i3

**`Super` is the mod key.**

| Keybind | Action |
|---|---|
| `Super+Enter` | Open kitty terminal |
| `Super+D` | Rofi app launcher |
| `Super+Shift+Q` | Close window |
| `Super+H/V` | Split horizontal/vertical |
| `Super+F` | Fullscreen |
| `Super+S/W/E` | Layout: stacking / tabbed / split |
| `Super+Space` | Toggle tiling/floating |
| `Super+1…0` | Switch to workspace 1–10 |
| `Super+Shift+1…0` | Move window to workspace and follow |
| `Super+Shift+I` | Lock screen (i3lock, black) |
| `Super+Shift+P` | Power off |
| `Super+Shift+O` | Reboot |
| `Super+Shift+S` | Screenshot (flameshot GUI) |
| `Super+M` | Apple Music (Chromium app mode) |
| `Super+R` | Enter resize mode |
| `Super+Shift+C` | Reload i3 config |
| `Super+Shift+R` | Restart i3 in-place |
| `Super+Shift+E` | Exit i3 |
| `Super+−` | Toggle scratchpad |
| `Super+Shift+−` | Send to scratchpad |

**Resize mode** (`Super+R`): arrow keys or `J/K/L/;` resize the focused window. Exit with `Enter`, `Escape`, or `Super+R`.

Audio keys (XF86) control PulseAudio volume via `pactl`.

Config: `.config/i3/config`

---

### Status bar — polybar

Dark bar (#282A2E) with rounded corners, sitting at the top of the screen.

```
[workspaces] [keyboard] [🎵 song] [window title]  |  date & time  |  VOL  RAM  CPU  wifi  battery
```

| Module | What it shows |
|---|---|
| `xworkspaces` | All 10 workspaces; active highlighted in gold |
| `xkeyboard` | Caps/Num lock indicators |
| `music` | Currently playing track (custom script polling MPRIS) |
| `xwindow` | Focused window title, truncated at 60 chars |
| `date` | `DD/MM/YYYY \| HH:MM:SS` |
| `pulseaudio` | Volume % or "muted" |
| `memory` | RAM % used |
| `cpu` | CPU % used, refreshed every 2 s |
| `wlan` | Interface name + SSID + local IP |
| `battery` | BAT1 level; low-at 20%, full-at 99% |

Config: `.config/polybar/config.ini`, `.config/polybar/music.sh`, `.config/polybar/cava.sh`

---

### Terminal — kitty

GPU-accelerated terminal with **60% background opacity** (requires a compositor).

Config: `.config/kitty/kitty.conf`

---

### Compositor — picom

GLX backend with:
- Drop shadows (radius 5, low opacity 0.3)
- Shadows disabled on notifications, docks, Chromium, i3 frames, and hidden windows
- Opacity stays at 1.0 for active and inactive windows (transparency comes from kitty itself)

Config: `.config/picom.conf`

---

### App launcher — rofi

Custom `darkblue-games` theme. Modes: `drun` (desktop apps) and `games`.
Triggered by `Super+D` from i3.

Config: `.config/rofi/config.rasi`, `.config/rofi/themes/darkblue-games.rasi`

---

### Notifications — dunst

Material-ish dark theme (`#263238` background).

| Urgency | Timeout |
|---|---|
| Low | 10 s |
| Normal | 10 s |
| Critical | Never (stays until dismissed) |

Shortcuts: `Alt+Space` dismiss, `Ctrl+Alt+Space` dismiss all, `Ctrl+Super+H` history.

Config: `.config/dunst/dunstrc`

---

### Display management — autorandr

Three saved profiles, applied automatically on startup and on hotplug via `exec_always --no-startup-id autorandr --change`.

| Profile | Description |
|---|---|
| `solo` | Laptop screen only |
| `externo` | External monitor only |
| `duplicado` | Both screens mirrored |

Config: `.config/autorandr/`

---

### Other tools

| Tool | Config | Purpose |
|---|---|---|
| **ranger** | `.config/ranger/rc.conf` | Terminal file manager with devicon support |
| **btop** | `.config/btop/btop.conf` | Resource monitor |
| **cava** | `.config/cava/config` | Terminal audio visualizer |
| **neofetch** | `.config/neofetch/config.conf` | System info display |
| **nitrogen** | `.config/nitrogen/` | Wallpaper manager (restores on login) |
| **flameshot** | `.config/flameshot/flameshot.ini` | Screenshot tool |
| **networkmanager-dmenu** | `.config/networkmanager-dmenu/config.ini` | Network selector via rofi/dmenu |

---

### X11 & GTK

| File | Purpose |
|---|---|
| `.xinitrc` | Starts i3 via dbus-launch; merges Xresources and Xmodmap |
| `.Xresources` | DPI 96, antialiasing, terminal color palette (dark teal base) |
| `.gtkrc-2.0` | GTK2 theme settings |
| `.config/gtk-3.0/` | GTK3 theme + CSS overrides |

---

### Git

`.gitconfig` sets `autocrlf = input` and enables Git LFS for binary files.

---

## Differences from the default Manjaro i3

The default Manjaro i3 community edition comes with a heavily modified config. Here's what changed:

| Area | Default Manjaro i3 | This config |
|---|---|---|
| **Terminal** | `$TERMINAL` (usually urxvt/xterm) | `kitty` |
| **Launcher** | `dmenu_recency` + `morc_menu` | `rofi` (drun + games) |
| **Window borders** | 1px pixel borders | Borderless (`border pixel 0`) |
| **Gaps** | Inner 14, outer −2 | Inner 10, outer 3 |
| **Workspaces** | 8 | 10 |
| **Audio** | `volumeicon` tray app + alsamixer binding | Pure `pactl` via media keys |
| **Screenshots** | `i3-scrot` (Print key variants) | `flameshot gui` (`Super+Shift+S`) |
| **Lock screen** | `blurlock` | `i3lock -c 000000` (plain black) |
| **Power menu** | `i3exit` mode (lock/suspend/hibernate/reboot/shutdown) | Direct binds: `Super+Shift+I` lock, `Super+Shift+P` poweroff, `Super+Shift+O` reboot |
| **Autorandr** | Not present | `exec_always autorandr --change` |
| **Compositor** | Started alongside nitrogen | `exec --no-startup-id picom` (separate) |
| **Bar** | `exec_always polybar example` | Kill-and-restart pattern to avoid duplicate bars |
| **Floating rules** | Extensive list (Nitrogen, Pavucontrol, GParted, etc.) | Removed (handled by window class as needed) |
| **Gap mode** | `Super+Shift+G` interactive gap adjustment | Removed |
| **Back-and-forth** | `workspace_auto_back_and_forth yes` | Removed |
| **Sticky toggle** | `Super+Shift+S` | Removed (key reused for flameshot) |
| **Resize steps** | 5px/5ppt | 10px/10ppt, direction logic inverted |
| **System tray** | `pamac-tray`, `clipit`, `polkit-gnome` | Only `nm-applet` |
| **Startup apps** | Firefox, xautolock, ff-theme-util, fix_xcursor | Minimal: autorandr, nm-applet, nitrogen, polybar, picom |

---

## Dependencies

Install these on a fresh Manjaro/Arch system before running `install.sh`:

```bash
sudo pacman -S i3-wm polybar kitty rofi picom dunst \
    nitrogen autorandr flameshot ranger btop cava neofetch \
    networkmanager network-manager-applet \
    i3lock xss-lock dex \
    zsh curl git
```

Git LFS (for binary assets in any repos):
```bash
sudo pacman -S git-lfs
git lfs install
```
