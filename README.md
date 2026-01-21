# Dotfiles

[![Test Dotfiles Setup](https://github.com/moabukar/dotfiles/actions/workflows/test.yml/badge.svg)](https://github.com/moabukar/dotfiles/actions/workflows/test.yml)

macOS dev env setup automation.

Context: Whenever you change jobs or switch to a new machine, it can be a headache to setup your dev environment for full efficiency. This repo aims to automate the setup process for a consistent and efficient dev environment.

## New Mac Setup

```bash
git clone https://github.com/moabukar/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./bootstrap.sh
```

Takes roughly 15 minutes for setup to complete.

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

### Shell & Editor

- Oh My Zsh + Powerlevel10k
- 100+ DevOps aliases (Git, Docker, K8s, AWS, etc.)
- Custom functions for DevOps workflows
- Vim config with DevOps-friendly settings
- Tmux config for terminal multiplexing

### Automatic Configuration

- Small, fixed dock with your preferred apps
- Trackpad: bottom-right corner = right-click
- Disabled natural scrolling (traditional scroll)
- Tap to click enabled
- All configs symlinked (.zshrc, .gitconfig, .vimrc, .tmux.conf)
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

### Pre-commit Hooks (Optional)

```bash
cd ~/.dotfiles
pre-commit install
```

Now git commits will automatically run shellcheck and file validation checks.

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

## Guides & Productivity Kit

- `docs/VIM_GUIDE.md` - Complete Vim tutorial for DevOps engineers
- `docs/TMUX_GUIDE.md` - Tmux from basics to advanced workflows
- `docs/DEVOPS_PRODUCTIVITY.md` - Shell workflows, Git tricks, K8s productivity, AWS patterns, secrets management, browser extensions, and more


## Run Scripts Individually

```bash
# Reconfigure dock
~/.dotfiles/scripts/dock.sh

# Reapply macOS defaults
~/.dotfiles/scripts/defaults.sh

# Reinstall VS Code extensions
~/.dotfiles/scripts/code.sh
```
