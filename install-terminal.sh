#!/usr/bin/env bash
# Usage: curl -fsSL https://raw.githubusercontent.com/asieramigorena/dotfiles/main/install-terminal.sh | bash
set -e

HOME_DIR="$HOME"
RAW="https://raw.githubusercontent.com/asieramigorena/dotfiles/main"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

info()  { echo -e "${GREEN}[+]${NC} $1"; }
warn()  { echo -e "${YELLOW}[!]${NC} $1"; }
error() { echo -e "${RED}[x]${NC} $1"; }

fetch() {
    local file="$1"
    local dst="$HOME_DIR/$file"

    if [ -e "$dst" ] && [ ! -L "$dst" ]; then
        warn "Backing up existing $dst → ${dst}.bak"
        mv "$dst" "${dst}.bak"
    fi

    curl -fsSL "$RAW/$file" -o "$dst"
    info "Installed $dst"
}

# ── Distro detection ──────────────────────────────────────────────────────────
if command -v apt-get &>/dev/null; then
    DISTRO="debian"
elif command -v pacman &>/dev/null; then
    DISTRO="arch"
else
    error "No supported package manager found (apt-get or pacman required)."
    exit 1
fi

info "Detected distro family: $DISTRO"

# ── System packages ───────────────────────────────────────────────────────────
info "Installing system packages (zsh, git, curl)..."
if [ "$DISTRO" = "debian" ]; then
    sudo apt-get update -qq
    sudo apt-get install -y zsh git curl
else
    sudo pacman -S --needed --noconfirm zsh git curl
fi

# ── oh-my-zsh ─────────────────────────────────────────────────────────────────
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

# ── Dotfiles ──────────────────────────────────────────────────────────────────
fetch .zshrc
fetch .bashrc
fetch .bash_profile
fetch .p10k.zsh
fetch .dir_colors
fetch .nanorc

# ── Default shell ─────────────────────────────────────────────────────────────
ZSH_BIN="$(which zsh)"
if [ "$SHELL" != "$ZSH_BIN" ]; then
    info "Changing default shell to zsh..."
    chsh -s "$ZSH_BIN"
fi

info "Done. Log out and back in (or run: exec zsh) to start using your terminal setup."
