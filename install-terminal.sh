#!/usr/bin/env bash
set -e

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOME_DIR="$HOME"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

info()  { echo -e "${GREEN}[+]${NC} $1"; }
warn()  { echo -e "${YELLOW}[!]${NC} $1"; }
error() { echo -e "${RED}[x]${NC} $1"; }

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
link "$DOTFILES/.zshrc"        "$HOME_DIR/.zshrc"
link "$DOTFILES/.bashrc"       "$HOME_DIR/.bashrc"
link "$DOTFILES/.bash_profile" "$HOME_DIR/.bash_profile"
link "$DOTFILES/.p10k.zsh"     "$HOME_DIR/.p10k.zsh"
link "$DOTFILES/.dir_colors"   "$HOME_DIR/.dir_colors"
link "$DOTFILES/.nanorc"       "$HOME_DIR/.nanorc"

# ── Default shell ─────────────────────────────────────────────────────────────
ZSH_BIN="$(which zsh)"
if [ "$SHELL" != "$ZSH_BIN" ]; then
    info "Changing default shell to zsh..."
    chsh -s "$ZSH_BIN"
fi

info "Done. Log out and back in (or run: exec zsh) to start using your terminal setup."
