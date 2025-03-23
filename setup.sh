#!/usr/bin/env bash
set -ex

# Define DOTFILES_DIR for ease
DOTFILES_DIR="$(pwd)"

# --- Homebrew ---
if ! command -v brew >/dev/null 2>&1; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
echo "Running brew bundle..."
brew bundle --global

# --- Git Config ---
echo "Linking git configuration..."
ln -sf "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"
ln -sf "$DOTFILES_DIR/git/.gitignore" "$HOME/.gitignore"
git config --global core.excludesfile "$HOME/.gitignore"
git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"
git config --global interactive.diffFilter "diff-so-fancy --patch"

# --- VS Code Setup ---
echo "Linking VSCode settings..."
VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"
mkdir -p "$VSCODE_USER_DIR"
ln -sf "$DOTFILES_DIR/vscode/settings.json" "$VSCODE_USER_DIR/settings.json"

if command -v code >/dev/null 2>&1; then
    while IFS= read -r extension || [[ -n "$extension" ]]; do
        code --install-extension "$extension" --force
    done < "$DOTFILES_DIR/vscode/extensions.txt"
else
    echo "VS Code command 'code' not found. Skipping extension installation."
fi

# --- Zsh Setup ---
echo "Linking Zsh configuration..."
ln -sf "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
# uncomment if you maintain a .zshenv:
# ln -sf "$DOTFILES_DIR/zsh/.zshenv" "$HOME/.zshenv"

# --- oh-my-zsh ---
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# --- zsh-syntax-highlighting Plugin ---
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    echo "Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

# --- powerlevel10k Theme ---
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
    echo "Installing powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
fi
ln -sf "$DOTFILES_DIR/p10k/.p10k.zsh" "$HOME/.p10k.zsh"

echo "Setup complete!"
