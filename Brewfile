# ============================================================================
# Unified Brewfile - macOS Development Setup
# ============================================================================
# Installation: brew bundle --file=Brewfile
# Or run: ./bootstrap.sh (which includes this)
# ============================================================================

# ----------------------------------------------------------------------------
# Taps
# ----------------------------------------------------------------------------
tap "hashicorp/tap"
tap "productdevbook/tap"

# ----------------------------------------------------------------------------
# Shell & Terminal
# ----------------------------------------------------------------------------
brew "zsh"
brew "bash"
brew "bash-completion"
brew "zsh-syntax-highlighting"
brew "zsh-autosuggestions"
brew "zsh-completions"
brew "tmux"
brew "screen"
cask "iterm2"

# ----------------------------------------------------------------------------
# Development Tools & IDEs
# ----------------------------------------------------------------------------
brew "git" # already installed on macOS by default?
brew "gh"                    # GitHub CLI
brew "node"
brew "python3" # already installed on macOS by default?
brew "go"
brew "rust"
cask "visual-studio-code"
cask "cursor"               # AI-powered code editor

# ----------------------------------------------------------------------------
# Version Managers
# ----------------------------------------------------------------------------
brew "pyenv"
brew "tfenv"

# ----------------------------------------------------------------------------
# Go Tools
# ----------------------------------------------------------------------------
brew "golangci-lint"
brew "goreleaser"
brew "gotests"

# ----------------------------------------------------------------------------
# Infrastructure as Code
# ----------------------------------------------------------------------------
brew "opentofu"             # Open source Terraform alternative
brew "terraform"            # HashiCorp Terraform
brew "terragrunt"
brew "hashicorp/tap/vault"
brew "hadolint"             # Dockerfile linter

# ----------------------------------------------------------------------------
# Kubernetes Tools
# ----------------------------------------------------------------------------
brew "kubernetes-cli"
brew "kubectx"
brew "kube-ps1"
brew "krew"
brew "helm"
brew "k3d"
brew "kind"
brew "minikube"
brew "skaffold"
brew "kustomize"
brew "tilt"
brew "k9s"                  # Terminal UI for Kubernetes
brew "stern"                # Multi-pod log tailing
brew "kubetail"             # Tail logs from multiple pods
brew "istioctl"             # Istio service mesh CLI
brew "linkerd"              # Linkerd service mesh

# ----------------------------------------------------------------------------
# Container Tools
# ----------------------------------------------------------------------------
brew "dive"                 # Explore Docker image layers
brew "crane"                # Container registry tool

# ----------------------------------------------------------------------------
# Cloud & Virtualization Tools
# ----------------------------------------------------------------------------
brew "awscli"               # AWS CLI
brew "azure-cli"            # Azure CLI
brew "doctl"                # DigitalOcean CLI
cask "1password-cli"        # 1Password CLI
brew "localstack"           # AWS local testing
brew "lima"                 # Linux virtual machines
brew "qemu"                 # Generic virtualization
brew "traefik"              # Reverse proxy

# ----------------------------------------------------------------------------
# DevOps & Cloud Tools
# ----------------------------------------------------------------------------
brew "jq"                   # JSON processor
brew "yq"                   # YAML processor
brew "jless"                # Interactive JSON viewer
brew "jnv"                  # Interactive JSON filter
brew "task"                 # Task runner
brew "opa"                  # Open Policy Agent
brew "cfssl"                # CloudFlare SSL
brew "ko"                   # Kubernetes image builder
brew "act"                  # Run GitHub Actions locally
brew "grpcurl"              # curl for gRPC
brew "glow"                 # Render markdown in terminal

# ----------------------------------------------------------------------------
# Security & Scanning
# ----------------------------------------------------------------------------
brew "trivy"                # Container/IaC vulnerability scanner
brew "tfsec"                # Terraform security scanner
brew "checkov"              # IaC security scanner
brew "sops"                 # Encrypted secrets in git
brew "age"                  # Simple file encryption
brew "mkcert"               # Local HTTPS certificates
brew "cosign"               # Sign/verify container images

# ----------------------------------------------------------------------------
# System Tools & CLI Utilities
# ----------------------------------------------------------------------------
brew "make"
brew "tree"
# brew "wget" already installed on macOS by default
brew "vim"
brew "tmux"                 # Terminal multiplexer
brew "fzf"                  # Fuzzy finder
brew "ripgrep"              # Fast grep alternative
brew "fd"                   # Fast find alternative
brew "direnv"               # Directory-based env vars
brew "bats"                 # Bash testing framework
brew "tlrc"                 # Simplified man pages (tldr replacement)
brew "shellcheck"           # Shell script linter
brew "yamllint"             # YAML linter

# ----------------------------------------------------------------------------
# "Better" CLI Tools
# ----------------------------------------------------------------------------
brew "bat"                  # Better cat with syntax highlighting
brew "eza"                  # Better ls
brew "btop"                 # Better top
brew "dust"                 # Better du
brew "procs"                # Better ps
brew "httpie"               # Better curl
brew "xh"                   # Even friendlier HTTP client
brew "mtr"                  # Better traceroute
brew "doggo"                # Better dig/DNS client
brew "delta"                # Better git diff
brew "zoxide"               # Smarter cd command

# ----------------------------------------------------------------------------
# Git Tools
# ----------------------------------------------------------------------------
brew "lazygit"              # Terminal UI for git
brew "tig"                  # Git repository browser
brew "git-lfs"              # Large file support
brew "diff-so-fancy"        # Better git diff
brew "pre-commit"           # Git pre-commit hooks framework

# ----------------------------------------------------------------------------
# Database Tools
# ----------------------------------------------------------------------------
brew "postgresql"
brew "mysql-client"
brew "redis"
brew "telnet"
brew "coreutils"
brew "findutils"
brew "less"
brew "gawk"
brew "gnutls"
brew "parallel"
brew "ncdu"                 # Disk usage analyzer
brew "watch"
brew "openssl"
brew "openssh"
brew "protobuf"
brew "dockutil"             # Manage macOS Dock
cask "portkiller"           # Kill processes on specific ports

# ----------------------------------------------------------------------------
# Performance & Load Testing
# ----------------------------------------------------------------------------
brew "k6"                   # Modern load testing tool
brew "wrk"                  # HTTP benchmarking
brew "vegeta"               # HTTP load testing

# ----------------------------------------------------------------------------
# Security & Encryption
# ----------------------------------------------------------------------------
brew "gnupg"
brew "gpg"

# ----------------------------------------------------------------------------
# Desktop Applications
# ----------------------------------------------------------------------------
cask "rectangle"            # Window management
cask "google-chrome"
cask "firefox"
cask "slack"
cask "discord"
cask "notion"               # Note-taking & productivity
cask "whatsapp"             # Messaging
cask "zoom"                 # Video conferencing
cask "microsoft-teams"      # Team collaboration
cask "orbstack"             # Fast Docker & Linux on macOS
cask "google-cloud-sdk"     # Google Cloud SDK

# ----------------------------------------------------------------------------
# Fonts (for Powerlevel10k)
# ----------------------------------------------------------------------------
cask "font-meslo-lg-nerd-font"

# Note: VS Code extensions are installed via scripts/code.sh
# See config/vscode/extensions for the list
