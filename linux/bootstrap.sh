#!/bin/bash

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }

DOTFILES_DIR="$HOME/.dotfiles"
LINUX_DIR="$DOTFILES_DIR/linux"

info "Starting Ubuntu DevOps environment setup..."

# Check if running on Ubuntu/Debian
if [[ ! -f /etc/debian_version ]]; then
    error "This script is designed for Ubuntu/Debian systems"
    exit 1
fi

# Update system
info "Updating system packages..."
sudo apt update
sudo apt upgrade -y

# Install essential packages
info "Installing essential packages..."
sudo apt install -y \
    build-essential \
    curl \
    wget \
    git \
    vim \
    zsh \
    tmux \
    htop \
    tree \
    unzip \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release \
    xclip

success "Essential packages installed"

# Install Zsh and Oh My Zsh
info "Setting up Zsh and Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    success "Oh My Zsh installed"
else
    success "Oh My Zsh already installed"
fi

# Install Zsh plugins
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    info "Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    info "Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

# Install Powerlevel10k
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
    info "Installing Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
    success "Powerlevel10k installed"
fi

# Change default shell to zsh
if [ "$SHELL" != "$(which zsh)" ]; then
    info "Changing default shell to zsh..."
    chsh -s "$(which zsh)"
    success "Default shell changed to zsh"
fi

# Install Docker
info "Installing Docker..."
if ! command -v docker &> /dev/null; then
    curl -fsSL https://get.docker.com -o /tmp/get-docker.sh
    sudo sh /tmp/get-docker.sh
    sudo usermod -aG docker "$USER"
    success "Docker installed (logout/login required for group changes)"
else
    success "Docker already installed"
fi

# Install Docker Compose
info "Installing Docker Compose..."
if ! command -v docker-compose &> /dev/null; then
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    success "Docker Compose installed"
else
    success "Docker Compose already installed"
fi

# Install development tools
info "Installing development tools..."
"$LINUX_DIR/scripts/install-tools.sh"

# Link configs
info "Linking configuration files..."
"$DOTFILES_DIR/scripts/link.sh"

success "Setup complete!"
echo ""
warn "IMPORTANT: Logout and login again for all changes to take effect"
echo ""
info "Post-setup steps:"
echo "  1. Configure your terminal to use MesloLGS NF font"
echo "  2. Generate SSH key: ssh-keygen -t ed25519"
echo "  3. Run 'gh auth login' for GitHub CLI"
echo "  4. Start a new terminal session"
