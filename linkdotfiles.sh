#!/bin/bash

DOTFILES_DIR="$HOME/Documents/learning/dotfiles"

# Remove existing .zshrc if it's not a symlink
if [ -f "$HOME/.zshrc" ] || [ -L "$HOME/.zshrc" ]; then
    rm -f "$HOME/.zshrc"
fi

# symlink .zshrc
ln -s "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"

echo "✅ .zshrc is now linked to your dotfiles repo!"
