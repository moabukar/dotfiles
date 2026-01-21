# Dotfiles - Linux/Ubuntu Setup

Automated development environment setup for Ubuntu/Debian systems.

## Quick Start

```bash
git clone https://github.com/yourusername/dotfiles.git ~/.dotfiles
cd ~/.dotfiles/linux
./bootstrap.sh
```

Takes roughly 10-15 minutes.

## What Gets Installed

### System Packages
- Build tools (build-essential, make, cmake)
- Git, curl, wget, vim
- Zsh + Oh My Zsh + Powerlevel10k
- Tmux with custom config

### Development Tools
- **Languages:** Node.js (via nvm), Python3, Go, Rust
- **Containers:** Docker, Docker Compose
- **Kubernetes:** kubectl, helm, k9s, kubectx, stern
- **IaC:** OpenTofu, Terragrunt
- **Cloud:** AWS CLI, Azure CLI

### DevOps Tools
- kubectl, helm, k9s, stern, kubetail
- OpenTofu (Terraform alternative)
- Docker + Docker Compose
- AWS CLI, Azure CLI
- direnv, jq, yq, fzf, ripgrep

### Better CLI Tools
- bat (better cat)
- eza (better ls)
- btop (better top)
- fd (better find)
- httpie (better curl)
- delta (better git diff)
- zoxide (smarter cd)

## Post-Setup

### SSH Key
```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
cat ~/.ssh/id_ed25519.pub | xclip -selection clipboard
```

### GitHub CLI
```bash
gh auth login
```

### GPG for Signed Commits
```bash
~/.dotfiles/linux/scripts/gpg-setup.sh
```

## Manual Steps

### Font (for Powerlevel10k)
Download and install MesloLGS NF:
```bash
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
fc-cache -fv
```

Set in your terminal preferences.

## Updating

```bash
cd ~/.dotfiles/linux
./scripts/update.sh
```

## Differences from macOS Version

- Uses `apt` instead of Homebrew
- No macOS-specific apps (iTerm2, Rectangle, etc.)
- Docker installed via official Docker repository
- Different system configurations (no Dock, trackpad settings)
- Uses `xclip` instead of `pbcopy`

## Tested On

- Ubuntu 22.04 LTS (Jammy)
- Ubuntu 20.04 LTS (Focal)
- Debian 11 (Bullseye)
