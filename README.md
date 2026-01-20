# Dotfiles

[![Test Dotfiles Setup](https://github.com/moabukar/dotfiles/actions/workflows/test.yml/badge.svg)](https://github.com/moabukar/dotfiles/actions/workflows/test.yml)

macOS dev env setup automation.

## New Mac Setup

```bash
git clone https://github.com/moabukar/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./bootstrap.sh
```

Takes roughly 15/20 minutes for setup to complete. 

## What Gets Installed

### Tools

**Languages & Runtimes**
- Node, Python, Go, Rust

**Kubernetes**
- kubectl, helm, k9s, kubectx, stern, kubetail
- k3d, kind, minikube, skaffold, kustomize, tilt

**Infrastructure**
- OpenTofu (Terraform alternative), Terragrunt, Vault
- AWS CLI, Azure CLI, LocalStack

**Containers**
- OrbStack, dive, crane, trivy (scanner)

**Security**
- trivy (container/IaC scanner), tfsec (Terraform scanner)

**Better CLI**
- bat (cat), eza (ls), btop (top), httpie (curl)
- lazygit, ripgrep, fzf, fd, dust, procs

**Testing**
- act (GitHub Actions local), hey (load testing)

### Apps

- Cursor, VS Code
- Chrome, Firefox
- iTerm2
- Notion, Slack, Discord
- WhatsApp, Teams, Zoom
- Rectangle (window management)

### Shell

- Oh My Zsh + Powerlevel10k
- 100+ DevOps aliases (Git, Docker, K8s, AWS, etc.)
- Custom functions

### Automatic Configuration

- Small, fixed dock with your preferred apps
- Trackpad: bottom-right corner = right-click
- Disabled natural scrolling (traditional scroll)
- Tap to click enabled
- All configs linked (.zshrc, .gitconfig, .vimrc, .tmux.conf)
- VS Code settings & extensions

## Post-Setup (2 minutes)

### SSH Key

```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
cat ~/.ssh/id_ed25519.pub | pbcopy
```
Add to GitHub: https://github.com/settings/ssh/new

### iTerm2 Font

Set font to **MesloLGS NF** in: iTerm2 → Preferences → Profiles → Text

### GitHub CLI

```bash
gh auth login
```

## Custom Functions

Type `aliases` to see all extras:

```bash
# Kubernetes
kln <partial>       # logs by partial pod name
kexn <partial>      # exec into pod
ksecdec <sec> <key> # decode secret
kdebug              # run debug pod

# Docker
dsh <container>     # shell into container
dbash <container>   # bash into container

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

## Customisation

```bash
# Edit shell & aliases
vi ~/.zshrc

# Edit dock apps
vi ~/.dotfiles/scripts/dock.sh

# Edit macOS settings
vi ~/.dotfiles/scripts/defaults.sh

# Add/remove packages
vi ~/.dotfiles/Brewfile
```

## Updating

```bash
cd ~/.dotfiles
git pull
brew update && brew upgrade
brew bundle --file=Brewfile
```

## Run Scripts Individually

```bash
# Reconfigure dock
~/.dotfiles/scripts/dock.sh

# Reapply macOS defaults
~/.dotfiles/scripts/defaults.sh

# Reinstall VS Code extensions
~/.dotfiles/scripts/code.sh
```
