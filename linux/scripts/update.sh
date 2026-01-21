#!/bin/bash

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

info() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }

info "Updating system..."
sudo apt update && sudo apt upgrade -y

info "Updating Oh My Zsh..."
"$ZSH/tools/upgrade.sh"

info "Updating Zsh plugins..."
cd "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" && git pull
cd "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" && git pull

info "Updating Powerlevel10k..."
cd "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" && git pull

info "Updating Rust..."
rustup update

info "Updating Node.js..."
if command -v nvm &> /dev/null; then
    nvm install --lts --latest-npm
fi

success "All updates complete!"
