#!/usr/bin/env bash
# alma-wsl/bootstrap.sh
# AlmaLinux on WSL — install shell, dev tools, oh-my-zsh, p10k, then link configs.

set -euo pipefail

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; NC='\033[0m'
info()    { echo -e "${BLUE}[INFO]${NC} $*"; }
ok()      { echo -e "${GREEN}[ OK ]${NC} $*"; }
warn()    { echo -e "${YELLOW}[WARN]${NC} $*"; }
err()     { echo -e "${RED}[FAIL]${NC} $*"; }

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DOTFILES_DIR="$( cd "$SCRIPT_DIR/.." && pwd )"

if [[ ! -f /etc/almalinux-release ]] && ! grep -qi almalinux /etc/os-release 2>/dev/null; then
  warn "Not detected as AlmaLinux — continuing anyway."
fi

# ---------------------------------------------------------------------------
# System packages (dnf)
# ---------------------------------------------------------------------------
info "Installing EPEL + dev tools via dnf (sudo)..."
sudo dnf install -y epel-release
sudo dnf install -y \
  zsh git tmux vim curl wget \
  htop tree unzip jq make \
  gcc gcc-c++ \
  ca-certificates \
  bash-completion \
  procps-ng iproute net-tools \
  fzf ripgrep
ok "Base packages installed."

# ---------------------------------------------------------------------------
# Oh My Zsh + plugins + Powerlevel10k (user space, no sudo)
# ---------------------------------------------------------------------------
ZSH_DIR="${ZSH:-$HOME/.oh-my-zsh}"
ZSH_CUSTOM="${ZSH_CUSTOM:-$ZSH_DIR/custom}"

if [[ ! -d "$ZSH_DIR" ]]; then
  info "Cloning oh-my-zsh..."
  git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$ZSH_DIR"
  ok "oh-my-zsh installed."
else
  ok "oh-my-zsh already present."
fi

clone_if_missing() {
  local repo="$1" dest="$2"
  if [[ ! -d "$dest" ]]; then
    info "Cloning $(basename "$dest")..."
    git clone --depth=1 "$repo" "$dest"
  fi
}

clone_if_missing https://github.com/zsh-users/zsh-autosuggestions       "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
clone_if_missing https://github.com/zsh-users/zsh-syntax-highlighting   "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
clone_if_missing https://github.com/zsh-users/zsh-completions            "$ZSH_CUSTOM/plugins/zsh-completions"
clone_if_missing https://github.com/romkatv/powerlevel10k                "$ZSH_CUSTOM/themes/powerlevel10k"

# ---------------------------------------------------------------------------
# Link configs
# ---------------------------------------------------------------------------
backup_and_link() {
  local src="$1" dst="$2"
  if [[ -e "$dst" && ! -L "$dst" ]]; then
    cp -a "$dst" "${dst}.bak.$(date +%Y%m%d%H%M%S)"
    info "Backed up existing $dst"
  fi
  ln -sfn "$src" "$dst"
  ok "Linked $dst -> $src"
}

backup_and_link "$SCRIPT_DIR/.zshrc"   "$HOME/.zshrc"
backup_and_link "$SCRIPT_DIR/.p10k.zsh" "$HOME/.p10k.zsh"

# ---------------------------------------------------------------------------
# Default shell
# ---------------------------------------------------------------------------
if [[ "$SHELL" != "$(command -v zsh)" ]]; then
  info "Changing default shell to zsh..."
  if chsh -s "$(command -v zsh)"; then
    ok "Default shell changed. Open a new terminal to take effect."
  else
    warn "chsh failed — run manually: chsh -s \$(command -v zsh)"
  fi
else
  ok "zsh already default shell."
fi

echo
ok "alma-wsl bootstrap complete."
echo "Next: open a new WSL session (or 'exec zsh') to start using the new shell."
