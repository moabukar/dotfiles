# Dotfiles

[![Test Dotfiles Setup](https://github.com/moabukar/dotfiles/actions/workflows/test.yml/badge.svg)](https://github.com/moabukar/dotfiles/actions/workflows/test.yml)

macOS dev env setup automation.

## New Mac Setup

```bash
git clone https://github.com/moabukar/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./bootstrap.sh
```

Takes roughly 15/20 minutes for setup to complete

## What Gets Installed

### Tools & CLIs

- Homebrew (Core)
- Git, Node, Python, Go
- Docker, Kubernetes (kubectl, helm, k9s, kind)
- Terraform, Terragrunt, Vault
- AWS CLI, LocalStack
- VS Code, iTerm2, Chrome

### Shell Setup

- Oh My Zsh
- Powerlevel10k theme
- Syntax highlighting & autosuggestions
- Custom aliases & functions

### Configs Symlinked

- `.zshrc` - Shell configuration
- `.gitconfig` - Git settings
- `.vimrc` - Vim config
- `.tmux.conf` - tmux config
- VS Code settings & extensions
- SSH config

## After Setup

### Set iTerm2 Font

iTerm2 → Preferences → Profiles → Text → Font: **MesloLGS NF**

### Generate SSH Key

```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
cat ~/.ssh/id_ed25519.pub | pbcopy

```

Add to GitHub: https://github.com/settings/ssh/new

### Login to GitHub CLI

```bash
gh auth login
```

## Example Custom Functions

Type `aliases` to see all extras:

```bash
# Kubernetes
kln <partial>       # logs by partial pod name
kexn <partial>      # exec into pod by partial name
ksecdec <sec> <key> # decode secret
kdebug              # run debug pod

# Docker
dsh <container>     # shell into container
dbash <container>   # bash into container

# Terraform
tfpo [file]         # plan with output
tfap [file]         # apply from plan

# AWS
ec2ls               # list EC2 instances
eksls               # list EKS clusters
ecrlogin            # docker login to ECR
s3tree <bucket>     # show bucket structure

# Utils
mkcd <dir>          # mkdir and cd
extract <file>      # extract any archive
b64e/b64d           # base64 encode/decode
genpass [len]       # generate password
killport <port>     # kill process on port
gcap <msg>          # git add, commit, push
```

## Updating

```bash
cd ~/.dotfiles
git pull
brew update && brew upgrade
brew bundle --file=Brewfile
```

## Customization

- Edit `.zshrc` for shell config
- Edit `shell/aliases.sh` for custom functions
- Edit `Brewfile` for packages
- Edit configs in `config/` directory
