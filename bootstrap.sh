#!/usr/bin/env bash
# macOS Setup Script

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info() { printf "${BLUE}> %s${NC}\n" "$*"; }
success() { printf "${GREEN}✓ %s${NC}\n" "$*"; }
warn() { printf "${YELLOW}! %s${NC}\n" "$*"; }
error() { printf "${RED}✗ %s${NC}\n" "$*"; }

main() {
    echo ""
    echo "macOS Dotfiles Setup"
    echo "===================="
    echo ""
    
    # Skip prompts in CI or non-interactive mode
    if [[ -z "$CI" ]] && [[ -z "$NONINTERACTIVE" ]]; then
        read -p "Continue? (y/N) " -n 1 -r
        echo ""
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            warn "Aborted"
            exit 1
        fi
    else
        info "Running in non-interactive mode"
    fi

    # Xcode CLI Tools
    info "Checking Xcode Command Line Tools..."
    if ! xcode-select -p &>/dev/null; then
        info "Installing Xcode Command Line Tools..."
        xcode-select --install
        warn "Complete Xcode installation then re-run this script"
        exit 0
    fi
    success "Xcode Command Line Tools installed"

    # Homebrew
    info "Checking Homebrew..."
    if ! command -v brew &>/dev/null; then
        info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Add to PATH for Apple Silicon
        if [[ $(uname -m) == 'arm64' ]]; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
        success "Homebrew installed"
    else
        success "Homebrew already installed"
        info "Updating Homebrew..."
        brew update
    fi

    # Install packages
    info "Installing packages from Brewfile (this takes 10-30 min)..."
    if [ -f "$DOTFILES_DIR/Brewfile" ]; then
        info "Running: brew bundle --file=$DOTFILES_DIR/Brewfile --no-lock --verbose"
        if brew bundle --file="$DOTFILES_DIR/Brewfile" --no-lock --verbose; then
            success "All packages from Brewfile installed"
        else
            error "Some packages failed to install from Brewfile"
            warn "Continuing anyway..."
        fi
    fi

    # Oh My Zsh
    info "Setting up Oh My Zsh..."
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        success "Oh My Zsh installed"
    else
        success "Oh My Zsh already installed"
    fi

    # Zsh plugins
    ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
    
    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
        info "Installing zsh-syntax-highlighting..."
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
    fi

    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
        info "Installing zsh-autosuggestions..."
        git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    fi

    # Powerlevel10k
    if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
        info "Installing Powerlevel10k..."
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
        success "Powerlevel10k installed"
    fi

    # Link configs
    info "Linking configuration files..."
    "$DOTFILES_DIR/scripts/link.sh"

    # macOS defaults
    if [[ -z "$CI" ]] && [[ -z "$NONINTERACTIVE" ]]; then
        read -p "Apply macOS defaults? (y/N) " -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            "$DOTFILES_DIR/scripts/defaults.sh"
        fi
    else
        info "Skipping macOS defaults in CI mode"
    fi

    # VS Code
    if command -v code &>/dev/null; then
        if [[ -z "$CI" ]] && [[ -z "$NONINTERACTIVE" ]]; then
            read -p "Setup VS Code? (y/N) " -n 1 -r
            echo ""
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                "$DOTFILES_DIR/scripts/code.sh"
            fi
        else
            info "Skipping VS Code setup in CI mode"
        fi
    fi

    # Git config
    if [ ! -f "$HOME/.gitconfig" ] || ! grep -q "name" "$HOME/.gitconfig" 2>/dev/null; then
        if [[ -z "$CI" ]] && [[ -z "$NONINTERACTIVE" ]]; then
            info "Git configuration..."
            read -p "Git name: " git_name
            read -p "Git email: " git_email
            git config --global user.name "$git_name"
            git config --global user.email "$git_email"
            success "Git configured"
        else
            info "Skipping Git user config in CI mode"
            git config --global user.name "CI Test User" || true
            git config --global user.email "ci@test.local" || true
        fi
    fi

    echo ""
    echo "Setup Complete"
    echo "=============="
    echo ""
    echo "Next steps:"
    echo "  1. Restart terminal (or: source ~/.zshrc)"
    echo "  2. Type 'aliases' to see shortcuts"
    echo "  3. Generate SSH key: ssh-keygen -t ed25519 -C 'your_email'"
    echo "  4. iTerm2: Set font to MesloLGS NF"
    echo ""
}

main "$@"
