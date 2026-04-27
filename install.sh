#!/usr/bin/env bash
set -e

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOME_DIR="$HOME"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

info()    { echo -e "${GREEN}[+]${NC} $1"; }
warn()    { echo -e "${YELLOW}[!]${NC} $1"; }
error()   { echo -e "${RED}[x]${NC} $1"; }

link() {
    local src="$1"
    local dst="$2"
    local dir
    dir="$(dirname "$dst")"

    mkdir -p "$dir"

    if [ -e "$dst" ] && [ ! -L "$dst" ]; then
        warn "Backing up existing $dst → ${dst}.bak"
        mv "$dst" "${dst}.bak"
    fi

    ln -sf "$src" "$dst"
    info "Linked $dst"
}

# ── Root dotfiles ──────────────────────────────────────────────────────────────
link "$DOTFILES/.bash_profile"  "$HOME_DIR/.bash_profile"
link "$DOTFILES/.bashrc"        "$HOME_DIR/.bashrc"
link "$DOTFILES/.zshrc"         "$HOME_DIR/.zshrc"
link "$DOTFILES/.p10k.zsh"      "$HOME_DIR/.p10k.zsh"
link "$DOTFILES/.dir_colors"    "$HOME_DIR/.dir_colors"
link "$DOTFILES/.dmenurc"       "$HOME_DIR/.dmenurc"
link "$DOTFILES/.gitconfig"     "$HOME_DIR/.gitconfig"
link "$DOTFILES/.gtkrc-2.0"    "$HOME_DIR/.gtkrc-2.0"
link "$DOTFILES/.makepkg.conf"  "$HOME_DIR/.makepkg.conf"
link "$DOTFILES/.nanorc"        "$HOME_DIR/.nanorc"
link "$DOTFILES/.xinitrc"       "$HOME_DIR/.xinitrc"
link "$DOTFILES/.Xresources"    "$HOME_DIR/.Xresources"
link "$DOTFILES/.Xclients"      "$HOME_DIR/.Xclients"

# ── .config ───────────────────────────────────────────────────────────────────
link "$DOTFILES/.config/i3/config"                  "$HOME_DIR/.config/i3/config"
link "$DOTFILES/.config/kitty/kitty.conf"            "$HOME_DIR/.config/kitty/kitty.conf"
link "$DOTFILES/.config/polybar/config.ini"          "$HOME_DIR/.config/polybar/config.ini"
link "$DOTFILES/.config/polybar/cava.sh"             "$HOME_DIR/.config/polybar/cava.sh"
link "$DOTFILES/.config/polybar/music.sh"            "$HOME_DIR/.config/polybar/music.sh"
link "$DOTFILES/.config/rofi/config.rasi"            "$HOME_DIR/.config/rofi/config.rasi"
link "$DOTFILES/.config/rofi/themes/darkblue-games.rasi" "$HOME_DIR/.config/rofi/themes/darkblue-games.rasi"
link "$DOTFILES/.config/picom.conf"                  "$HOME_DIR/.config/picom.conf"
link "$DOTFILES/.config/dunst/dunstrc"               "$HOME_DIR/.config/dunst/dunstrc"
link "$DOTFILES/.config/btop/btop.conf"              "$HOME_DIR/.config/btop/btop.conf"
link "$DOTFILES/.config/cava/config"                 "$HOME_DIR/.config/cava/config"
link "$DOTFILES/.config/neofetch/config.conf"        "$HOME_DIR/.config/neofetch/config.conf"
link "$DOTFILES/.config/nitrogen/bg-saved.cfg"       "$HOME_DIR/.config/nitrogen/bg-saved.cfg"
link "$DOTFILES/.config/nitrogen/nitrogen.cfg"       "$HOME_DIR/.config/nitrogen/nitrogen.cfg"
link "$DOTFILES/.config/flameshot/flameshot.ini"     "$HOME_DIR/.config/flameshot/flameshot.ini"
link "$DOTFILES/.config/ranger/rc.conf"              "$HOME_DIR/.config/ranger/rc.conf"
link "$DOTFILES/.config/ranger/scope.sh"             "$HOME_DIR/.config/ranger/scope.sh"
link "$DOTFILES/.config/gtk-3.0/gtk.css"             "$HOME_DIR/.config/gtk-3.0/gtk.css"
link "$DOTFILES/.config/gtk-3.0/settings.ini"        "$HOME_DIR/.config/gtk-3.0/settings.ini"
link "$DOTFILES/.config/networkmanager-dmenu/config.ini" "$HOME_DIR/.config/networkmanager-dmenu/config.ini"
link "$DOTFILES/.config/nano/nanorc.nanorc"          "$HOME_DIR/.config/nano/nanorc.nanorc"

# Autorandr profiles
for profile in solo externo duplicado; do
    link "$DOTFILES/.config/autorandr/$profile/config" "$HOME_DIR/.config/autorandr/$profile/config"
    link "$DOTFILES/.config/autorandr/$profile/setup"  "$HOME_DIR/.config/autorandr/$profile/setup"
done

# XFCE4 (used for power manager / pointer settings even under i3)
link "$DOTFILES/.config/xfce4/helpers.rc" "$HOME_DIR/.config/xfce4/helpers.rc"
for xml in "$DOTFILES/.config/xfce4/xfconf/xfce-perchannel-xml/"*.xml; do
    name="$(basename "$xml")"
    link "$xml" "$HOME_DIR/.config/xfce4/xfconf/xfce-perchannel-xml/$name"
done

# ── Shell setup ───────────────────────────────────────────────────────────────
if [ ! -d "$HOME_DIR/.oh-my-zsh" ]; then
    info "Installing oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME_DIR/.oh-my-zsh/custom}"

if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
    info "Installing powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    info "Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autocomplete" ]; then
    info "Installing zsh-autocomplete..."
    git clone https://github.com/marlonrichert/zsh-autocomplete.git "$ZSH_CUSTOM/plugins/zsh-autocomplete"
fi

info "Done. Log out and back in (or: exec zsh) to apply shell changes."
