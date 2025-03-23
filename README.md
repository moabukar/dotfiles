# Dotfiles & Setup (macOS edition)

This repo automates my macOS setup for DevOps work. It symlinks dotfiles, installs essential apps via Homebrew, sets up your shell (oh-my-zsh & powerlevel10k) and aliases along with OS defaults.

## Prerequisites

- A new macOS machine. 
- Xcode Command Line Tools installed (if not, script will prompt)

## Quick Start

```bash
./setup.sh
```

This will:

- Install Homebrew (if missing)
- Symlink your dotfiles (e.g. .zshrc, aliases)
- Install Homebrew apps using `brew bundle --global` (see `homebrew/Brewfile`)
- Configure macOS defaults (`scripts/defaults.sh`)
- Install oh-my-zsh & powerlevel10k

## Customization

- **Homebrew:** Update `homebrew/Brewfile` to change your packages.
- **OS Defaults:** Adjust settings in `scripts/defaults.sh`.
- **Symlinks:** Update `linkdotfiles.sh` (or `scripts/link.sh`) if needed.

## Manual Steps

There's always things that you can't fully automate or it's better to do manually. Here are some things I prefer to do manually:

- Login to GitHub & add ssh keys.
  - `ssh-keygen` to generate a new key. 
  - `cat ~/.ssh/id_rsa.pub | pbcopy` to copy the key to clipboard & copy it to [GitHub](https://github.com/settings/ssh/new).
  - Now, try to clone your repos via SSH and see if it works.
- Clean up the mac dock & make the size smaller. 
- Setup VPN (im using [NordVPN](https://nordvpn.com/)) and login etc. Alongside with the NordPass.
- Setup Magnet shortcuts

## Repo Structure

```bash
├── LICENSE # MIT License
├── Makefile # (Optional) for running targets
├── README.md # Home README
├── git
│   └── aliases.zsh # Git aliases
├── homebrew
│   ├── Brewfile # Homebrew packages
│   ├── install.sh # Homebrew install script
│   └── path.zsh # Homebrew path script
├── linkdotfiles.sh # Dotfile symlinker
├── p10k # Powerlevel10k config
├── scripts
│   ├── asdf.sh # asdf install script
│   ├── brew.sh # Homebrew install script
│   ├── code.sh # VSCode install script
│   ├── defaults.sh # macOS defaults
│   ├── init.sh # Initial setup script
│   ├── link.sh # Dotfile symlinker
│   └── util.sh # Utility functions
├── setup.sh # Bootstrap script
├── ssh_config # SSH config
├── useful-commands.md # Useful commands
└── vscode
    ├── extensions # VSCode extensions
    └── settings.json # VSCode settings
```

## TODO

- Automate it further. 