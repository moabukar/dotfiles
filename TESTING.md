# Testing on Parallels

## Setup Parallels VM

1. Create new macOS VM in Parallels Desktop
2. Complete macOS setup wizard
3. Open Terminal

## Test Bootstrap

```bash
# Clone repo
git clone https://github.com/moabukar/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Run bootstrap
./bootstrap.sh
```

## Verify Installation

### Check Homebrew
```bash
brew --version
brew list
```

### Check Apps
```bash
# Should be installed:
ls /Applications | grep -E "iTerm|Code|Chrome|Slack"
```

### Check Shell
```bash
# Should show Oh My Zsh with Powerlevel10k
echo $ZSH_THEME

# Test aliases
aliases
k version
tf version
```

### Check Configs
```bash
# Git
cat ~/.gitconfig

# VS Code
ls ~/Library/Application\ Support/Code/User/settings.json

# Aliases
grep "shell/aliases" ~/.zshrc
```

## Common Issues

### Xcode CLI Tools
If installation pauses:
- Complete Xcode installation in GUI
- Re-run `./bootstrap.sh`

### Homebrew on ARM
Should auto-add to PATH. If not:
```bash
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
source ~/.zprofile
```

### VS Code 'code' command
- Open VS Code
- Cmd+Shift+P → "Shell Command: Install 'code' command in PATH"

## Snapshot

Take VM snapshot after successful setup for easy reset testing.
