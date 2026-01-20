# ~/.zshrc - Principal DevOps Engineer Configuration
# =================================================
# Created: $(date)
# Purpose: Comprehensive shell environment for DevOps workflows
# =================================================

# =================================================
# POWERLEVEL10K INSTANT PROMPT
# =================================================
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# =================================================
# ENVIRONMENT VARIABLES
# =================================================

# Locale and language
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Default editors
export EDITOR='vim'
export VISUAL='vim'

# Architecture flags
export ARCHFLAGS="-arch $(uname -m)"

# History configuration
export HISTFILE=~/.zsh_history
export HISTSIZE=50000
export SAVEHIST=50000

# Development directories
export WORKSPACE="$HOME/workspace"
export LEARNING_DIR="$HOME/Documents/Learning"
export PLATFORM_DIR="$HOME/Documents/Platform"

# Tool-specific configurations
export VAULT_ADDR='http://127.0.0.1:8200'
export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1

# =================================================
# PATH CONFIGURATION
# =================================================

# Initialize PATH with system defaults
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

# Homebrew paths (macOS)
if [[ "$OSTYPE" == "darwin"* ]]; then
  # Apple Silicon
  export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
  # Intel
  export PATH="/usr/local/bin:/usr/local/sbin:$PATH"
fi

# User local paths
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/bin:$PATH"

# Rancher Desktop
export PATH="$HOME/.rd/bin:$PATH"

# UTM (if using)
export PATH="/Applications/UTM.app/Contents/MacOS:$PATH"

# =================================================
# OH MY ZSH CONFIGURATION
# =================================================

# Path to Oh My Zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Theme configuration
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugin configuration
plugins=(
  git
  docker
  docker-compose
  kubectl
  terraform
  aws
  helm
  ansible
  node
  npm
  yarn
  z
  colored-man-pages
  command-not-found
  zsh-autosuggestions
  zsh-syntax-highlighting
)

# Oh My Zsh settings
DISABLE_AUTO_UPDATE="false"
DISABLE_UPDATE_PROMPT="false"
UPDATE_ZSH_DAYS=7
DISABLE_MAGIC_FUNCTIONS="false"
DISABLE_LS_COLORS="false"
DISABLE_AUTO_TITLE="false"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
DISABLE_UNTRACKED_FILES_DIRTY="false"

# Load Oh My Zsh (with error handling)
if [[ -f "$ZSH/oh-my-zsh.sh" ]]; then
  source "$ZSH/oh-my-zsh.sh"
else
  echo "⚠️  Oh My Zsh not found. Install with:"
  echo "sh -c \"\$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\""
fi

# =================================================
# COMPLETION SYSTEM
# =================================================

# Enable completion system
autoload -Uz compinit
compinit

# Completion options
setopt COMPLETE_IN_WORD
setopt ALWAYS_TO_END
setopt PATH_DIRS
setopt AUTO_MENU
setopt AUTO_LIST
setopt AUTO_PARAM_SLASH
setopt EXTENDED_GLOB

# Case insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'

# Completion colors
zstyle ':completion:*' list-colors ''
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'

# =================================================
# HISTORY CONFIGURATION
# =================================================

setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_BEEP
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY

# =================================================
# TOOL-SPECIFIC ENVIRONMENT SETUP
# =================================================

setup_nvm() {
  export NVM_DIR="$HOME/.nvm"
  if [[ -s "$NVM_DIR/nvm.sh" ]]; then
    source "$NVM_DIR/nvm.sh"
  fi
  if [[ -s "$NVM_DIR/bash_completion" ]]; then
    source "$NVM_DIR/bash_completion"
  fi
}

setup_go() {
  if command -v go >/dev/null 2>&1; then
    export GOPATH="$(go env GOPATH)"
    export GOROOT="$(go env GOROOT)"
    export GOBIN="$GOPATH/bin"
    export PATH="$GOBIN:$GOROOT/bin:$PATH"
  fi
}

setup_python() {
  # pyenv
  if command -v pyenv >/dev/null 2>&1; then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
  fi
  
  # pipx
  if [[ -d "$HOME/.local/bin" ]]; then
    export PATH="$HOME/.local/bin:$PATH"
  fi
}

# Kubernetes tools
setup_kubernetes() {
  # kubectl completion
  if command -v kubectl >/dev/null 2>&1; then
    source <(kubectl completion zsh)
    complete -F __start_kubectl k
  fi
  
  # helm completion
  if command -v helm >/dev/null 2>&1; then
    source <(helm completion zsh)
  fi
  
  # kubectx and kubens completion
  if [[ -d "/opt/homebrew/share/zsh/site-functions" ]]; then
    fpath=(/opt/homebrew/share/zsh/site-functions $fpath)
  fi
}

setup_gcloud() {
  local gcloud_path="$HOME/google-cloud-sdk"
  if [[ -f "$gcloud_path/path.zsh.inc" ]]; then
    source "$gcloud_path/path.zsh.inc"
  fi
  if [[ -f "$gcloud_path/completion.zsh.inc" ]]; then
    source "$gcloud_path/completion.zsh.inc"
  fi
}

setup_aws() {
  if command -v aws_completer >/dev/null 2>&1; then
    complete -C '/usr/local/bin/aws_completer' aws
  fi
}

setup_docker() {
  # Docker completion
  if [[ -f "/Applications/Docker.app/Contents/Resources/etc/docker.zsh-completion" ]]; then
    source "/Applications/Docker.app/Contents/Resources/etc/docker.zsh-completion"
  fi
  
  # Docker Compose completion
  if [[ -f "/Applications/Docker.app/Contents/Resources/etc/docker-compose.zsh-completion" ]]; then
    source "/Applications/Docker.app/Contents/Resources/etc/docker-compose.zsh-completion"
  fi
}

# Initialize all environments
setup_nvm
setup_go
setup_python
setup_kubernetes
setup_gcloud
setup_aws
setup_docker

# =================================================
# CUSTOM FUNCTIONS
# =================================================

# System information
sysinfo() {
  echo "🖥️  System Information"
  echo "━━━━━━━━━━━━━━━━━━━━━━━"
  echo "OS: $(uname -s) $(uname -r)"
  echo "Shell: $SHELL"
  echo "User: $(whoami)"
  echo "Hostname: $(hostname)"
  echo "Uptime: $(uptime | sed 's/.*up \([^,]*\),.*/\1/')"
  if command -v free >/dev/null 2>&1; then
    echo "Memory: $(free -h | awk '/^Mem:/ {print $3 "/" $2}')"
  fi
  echo "Disk Usage: $(df -h / | tail -1 | awk '{print $3 "/" $2 " (" $5 ")"}')"
  echo "Load Average: $(uptime | awk -F'load average:' '{print $2}' | sed 's/^[ \t]*//')"
}

# Enhanced file search
ff() {
  if [[ $# -eq 0 ]]; then
    echo "Usage: ff <pattern> [directory]"
    return 1
  fi
  local dir="${2:-.}"
  find "$dir" -type f -name "*$1*" 2>/dev/null | head -20
}

# Enhanced directory search
fd() {
  if [[ $# -eq 0 ]]; then
    echo "Usage: fd <pattern> [directory]"
    return 1
  fi
  local dir="${2:-.}"
  find "$dir" -type d -name "*$1*" 2>/dev/null | head -20
}

# Git utilities
gitpushup() {
  local current_branch
  current_branch=$(git symbolic-ref --short HEAD 2>/dev/null)
  if [[ -n "$current_branch" ]]; then
    echo "🚀 Pushing $current_branch and setting upstream..."
    git push --set-upstream origin "$current_branch"
  else
    echo "❌ Not in a git repository or no current branch"
    return 1
  fi
}

git_status_all() {
  for dir in */; do
    if [[ -d "$dir/.git" ]]; then
      echo "📁 $dir"
      cd "$dir"
      git status --porcelain
      cd ..
      echo
    fi
  done
}

# aws utils
awsprofile() {
  if [[ $# -eq 0 ]]; then
    echo "Current AWS Profile: ${AWS_PROFILE:-default}"
    echo "Available profiles:"
    aws configure list-profiles 2>/dev/null || echo "No profiles found"
  else
    export AWS_PROFILE="$1"
    echo "✅ AWS Profile set to: $1"
  fi
}

awswhoami() {
  echo "🔍 Current AWS Identity:"
  aws sts get-caller-identity 2>/dev/null || echo "❌ Not authenticated or AWS CLI not configured"
}

ec2-instances() {
  local profile="${1:-default}"
  echo "🖥️  EC2 Instances (Profile: $profile):"
  aws --profile "$profile" ec2 describe-instances \
    --query 'Reservations[].Instances[].[InstanceId,InstanceType,State.Name,Tags[?Key==`Name`].Value|[0]]' \
    --output table 2>/dev/null || echo "❌ Failed to fetch instances"
}

# k8s utils
k8s-ctx() {
  if command -v kubectx >/dev/null 2>&1; then
    kubectx
  else
    kubectl config get-contexts
  fi
}

k8s-ns() {
  if command -v kubens >/dev/null 2>&1; then
    kubens
  else
    kubectl get namespaces
  fi
}

k8s-pods-all() {
  echo "🐳 All Pods Across Namespaces:"
  kubectl get pods --all-namespaces -o wide
}

k8s-events() {
  echo "📋 Recent Kubernetes Events:"
  kubectl get events --sort-by='.lastTimestamp' | tail -20
}

# docker utils
docker-cleanup() {
  read "?🧹 This will remove all stopped containers, unused networks, images, and build cache. Continue? (y/N) " confirm
  if [[ "$confirm" =~ ^[Yy]$ ]]; then
    echo "🗑️  Cleaning up Docker..."
    docker system prune -af
    docker volume prune -f
    echo "✅ Docker cleanup complete"
  else
    echo "❌ Cleanup cancelled"
  fi
}

docker-stats() {
  echo "📊 Docker System Usage:"
  docker system df
  echo "\n🐳 Running Containers:"
  docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"
}

# multipass utils
multipass-status() {
  echo "🖥️  Multipass VM Status:"
  multipass list
}

multipass-cleanup() {
  read "?🧹 This will purge all deleted instances and recover disk space. Continue? (y/N) " confirm
  if [[ "$confirm" =~ ^[Yy]$ ]]; then
    echo "🗑️  Purging deleted instances..."
    multipass purge
    echo "✅ Multipass cleanup complete"
  else
    echo "❌ Cleanup cancelled"
  fi
}

# dev utils
httpserve() {
  local port="${1:-8000}"
  echo "🌐 Starting HTTP server on port $port..."
  if command -v python3 >/dev/null 2>&1; then
    python3 -m http.server "$port"
  elif command -v python >/dev/null 2>&1; then
    python -m SimpleHTTPServer "$port"
  else
    echo "❌ Python not found"
    return 1
  fi
}

# tf utils
tf-clean() {
  echo "🧹 Cleaning Terraform cache..."
  find . -type d -name ".terraform" -exec rm -rf {} + 2>/dev/null
  find . -type f -name ".terraform.lock.hcl" -delete 2>/dev/null
  find . -type f -name "terraform.tfstate.backup" -delete 2>/dev/null
  echo "✅ Terraform cache cleaned"
}

tg-clean() {
  echo "🧹 Cleaning Terragrunt cache..."
  find . -type d -name ".terragrunt-cache" -exec rm -rf {} + 2>/dev/null
  echo "✅ Terragrunt cache cleaned"
}

# quick service starters
run-redis() {
  docker run --rm -d --name redis -p 127.0.0.1:6379:6379 redis:alpine
  echo "✅ Redis started on localhost:6379"
}

run-postgres() {
  docker run --rm -d --name postgres \
    -e POSTGRES_PASSWORD=password \
    -e POSTGRES_DB=testdb \
    -p 127.0.0.1:5432:5432 postgres:15-alpine
  echo "✅ PostgreSQL started on localhost:5432 (user: postgres, password: password, db: testdb)"
}

run-mysql() {
  docker run --rm -d --name mysql \
    -e MYSQL_ROOT_PASSWORD=password \
    -e MYSQL_DATABASE=testdb \
    -p 127.0.0.1:3306:3306 mysql:8.0
  echo "✅ MySQL started on localhost:3306 (user: root, password: password, db: testdb)"
}

# load custom functions from external file
load_custom_functions() {
  local custom_functions="$HOME/.zsh_functions"
  if [[ -f "$custom_functions" ]]; then
    source "$custom_functions"
    echo "✅ Custom functions loaded from $custom_functions"
  fi
}

load_custom_functions

# =================================================
# ALIASES - NAVIGATION & BASIC
# =================================================

# nav
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ~='cd ~'
alias -- -='cd -'

# basics
alias c='clear'
alias h='history'
alias j='jobs -l'
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%T"'
alias nowtime=now
alias nowdate='date +"%d-%m-%Y"'
alias reload='source ~/.zshrc'

# Enhanced ls (use eza if available, otherwise ls)
if command -v eza >/dev/null 2>&1; then
  alias ls='eza --color=always --group-directories-first'
  alias ll='eza -la --color=always --group-directories-first'
  alias l='eza -l --color=always --group-directories-first'
  alias la='eza -a --color=always --group-directories-first'
  alias lt='eza -aT --color=always --group-directories-first'
else
  alias ll='ls -alF'
  alias la='ls -A'
  alias l='ls -CF'
fi

# Enhanced cat (use bat if available)
if command -v bat >/dev/null 2>&1; then
  alias cat='bat --style=auto'
  alias catn='cat --style=plain'
fi

# FileOps
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -iv'
alias mkdir='mkdir -pv'

# SysOps
alias df='df -H'
alias du='du -ch'
alias free='free -mt'
alias ps='ps auxf'
alias psg='ps aux | grep -v grep | grep -i -e VSZ -e'
alias myip='curl -s http://ipecho.net/plain; echo'
alias speedtest='curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python3 -'

# NetOps
alias ping='ping -c 5'
alias ports='netstat -tuln'
alias listening='lsof -i -P | grep LISTEN'

# =================================================
# ALIASES - GIT
# =================================================

alias g='git'
alias gi='git init'
alias gs='git status'
alias gss='git status --short'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit --amend'
alias gcane='git commit --amend --no-edit'
alias gb='git branch'
alias gba='git branch -a'
alias gbd='git branch -d'
alias gbD='git branch -D'
alias gco='git checkout'
alias gcob='git checkout -b'
alias gcmain='git checkout main'
alias gcd='git checkout develop'
alias gl='git log --oneline -10'
alias gll='git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'
alias gp='git pull'
alias gps='git push'
alias gpso='git push origin'
alias gpsf='git push --force-with-lease'
alias gd='git diff'
alias gds='git diff --staged'
alias gst='git stash'
alias gstp='git stash pop'
alias gstl='git stash list'
alias gr='git reset'
alias grh='git reset --hard'
alias grs='git reset --soft'
alias gm='git merge'
alias grb='git rebase'
alias grbi='git rebase -i'

# =================================================
# ALIASES - KUBERNETES
# =================================================

alias k='kubectl'
alias kaf='kubectl apply -f'
alias kdf='kubectl delete -f'

# Get resources
alias kg='kubectl get'
alias kga='kubectl get all'
alias kgaa='kubectl get all --all-namespaces'
alias kgp='kubectl get pods'
alias kgpa='kubectl get pods --all-namespaces'
alias kgs='kubectl get services'
alias kgsa='kubectl get services --all-namespaces'
alias kgd='kubectl get deployments'
alias kgda='kubectl get deployments --all-namespaces'
alias kgi='kubectl get ingress'
alias kgia='kubectl get ingress --all-namespaces'
alias kgn='kubectl get nodes'
alias kgns='kubectl get namespaces'
alias kgsec='kubectl get secrets'
alias kgcm='kubectl get configmaps'

# Describe resources
alias kd='kubectl describe'
alias kdp='kubectl describe pod'
alias kds='kubectl describe service'
alias kdd='kubectl describe deployment'
alias kdn='kubectl describe node'

# Edit resources
alias ke='kubectl edit'
alias kep='kubectl edit pod'
alias kes='kubectl edit service'
alias ked='kubectl edit deployment'

# Delete resources
alias kdel='kubectl delete'
alias kdelp='kubectl delete pod'
alias kdels='kubectl delete service'
alias kdeld='kubectl delete deployment'

# Logs and exec
alias kl='kubectl logs'
alias klf='kubectl logs -f'
alias kexec='kubectl exec -it'
alias kpf='kubectl port-forward'

# Contexts and namespaces
if command -v kubectx >/dev/null 2>&1; then
  alias kx='kubectx'
  alias kxc='kubectx -c'
  alias kxp='kubectx -'
fi

if command -v kubens >/dev/null 2>&1; then
  alias kns='kubens'
  alias knsc='kubens -c'
  alias knsp='kubens -'
fi

# Useful shortcuts
alias kwatch='watch kubectl get pods'
alias kevents='kubectl get events --sort-by=.metadata.creationTimestamp'
alias ktop='kubectl top nodes && echo && kubectl top pods'

# Quick contexts (adjust to your setup)
alias kdev='kubectl config use-context development'
alias kstg='kubectl config use-context staging'
alias kprd='kubectl config use-context production'

# =================================================
# ALIASES - DOCKER
# =================================================

alias d='docker'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias di='docker images'
alias dip='docker image prune -f'
alias dvp='docker volume prune -f'
alias dnp='docker network prune -f'
alias dsp='docker system prune -f'
alias dexec='docker exec -it'
alias dlogs='docker logs'
alias dlogsf='docker logs -f'
alias dstop='docker stop'
alias dstart='docker start'
alias drestart='docker restart'
alias drm='docker rm'
alias drmi='docker rmi'
alias dbuild='docker build'
alias drun='docker run'

# Docker Compose
alias dc='docker compose'
alias dcu='docker compose up'
alias dcud='docker compose up -d'
alias dcd='docker compose down'
alias dcb='docker compose build'
alias dcl='docker compose logs'
alias dclf='docker compose logs -f'
alias dcp='docker compose ps'
alias dcr='docker compose restart'
alias dce='docker compose exec'

# =================================================
# ALIASES - MULTIPASS
# =================================================

alias mp='multipass'
alias mpls='multipass list'
alias mps='multipass start'
alias mpst='multipass stop'
alias mpr='multipass restart'
alias mpd='multipass delete'
alias mpp='multipass purge'
alias mpi='multipass info'
alias mpe='multipass exec'
alias mpsh='multipass shell'
alias mpt='multipass transfer'
alias mpm='multipass mount'
alias mpu='multipass umount'
alias mpf='multipass find'
alias mpla='multipass launch'
alias mpstatus='multipass-status'
alias mpclean='multipass-cleanup'

# =================================================
# ALIASES - TERRAFORM & TERRAGRUNT
# =================================================

# Terraform
alias tf='terraform'
alias tfi='terraform init'
alias tfu='terraform init -upgrade'
alias tfp='terraform plan'
alias tfa='terraform apply'
alias tfd='terraform destroy'
alias tfs='terraform show'
alias tfv='terraform validate'
alias tff='terraform fmt'
alias tfmt='terraform fmt -recursive'
alias tfo='terraform output'
alias tfw='terraform workspace'
alias tfws='terraform workspace show'
alias tfwl='terraform workspace list'
alias tfsl='terraform state list'
alias tfss='terraform state show'

# Terragrunt
alias tg='terragrunt'
alias tgi='terragrunt init'
alias tgp='terragrunt plan'
alias tga='terragrunt apply'
alias tgd='terragrunt destroy'
alias tgf='terragrunt fmt'
alias tgv='terragrunt validate'
alias tgo='terragrunt output'

# Terragrunt run-all
alias tgrai='terragrunt run-all init'
alias tgrap='terragrunt run-all plan'
alias tgraa='terragrunt run-all apply'
alias tgrad='terragrunt run-all destroy'
alias tgrav='terragrunt run-all validate'

# =================================================
# ALIASES - AWS
# =================================================

alias awsp='awsprofile'
alias awsw='awswhoami'

# Common AWS commands
alias ec2='aws ec2'
alias s3='aws s3'
alias iam='aws iam'
alias cf='aws cloudformation'
alias logs='aws logs'
alias ssm='aws ssm'

# =================================================
# ALIASES - HELM
# =================================================

alias h='helm'
alias hi='helm install'
alias hu='helm upgrade'
alias hd='helm delete'
alias hl='helm list'
alias hla='helm list --all-namespaces'
alias hs='helm search'
alias hsr='helm search repo'
alias hr='helm repo'
alias hra='helm repo add'
alias hru='helm repo update'
alias hrl='helm repo list'
alias hv='helm version'
alias hh='helm history'

# =================================================
# ALIASES - ANSIBLE
# =================================================

alias a='ansible'
alias ap='ansible-playbook'
alias av='ansible-vault'
alias ag='ansible-galaxy'
alias ai='ansible-inventory'
alias ac='ansible-config'
alias ad='ansible-doc'

# =================================================
# CUSTOM DEVOPS FUNCTIONS
# =================================================

# Kubernetes - Partial name matching
kln() {
    kubectl logs -f "$(kubectl get pods | grep "$1" | head -1 | awk '{print $1}')"
}

kexn() {
    kubectl exec -it "$(kubectl get pods | grep "$1" | head -1 | awk '{print $1}')" -- /bin/sh
}

kbashexn() {
    kubectl exec -it "$(kubectl get pods | grep "$1" | head -1 | awk '{print $1}')" -- /bin/bash
}

# Kubernetes - Secret decoding
ksecdec() {
    kubectl get secret "$1" -o jsonpath="{.data.$2}" | base64 -d
}

ksecshow() {
    kubectl get secret "$1" -o json | jq -r '.data | to_entries[] | "\(.key): \(.value | @base64d)"'
}

# Kubernetes - Quick debug pod
kdebug() {
    kubectl run debug-pod --rm -it --image=alpine -- /bin/sh
}

# Docker - Shell helpers
dsh() {
    docker exec -it "$1" /bin/sh
}

dbash() {
    docker exec -it "$1" /bin/bash
}

# AWS - Formatted outputs
awswho() {
    aws sts get-caller-identity
}

ec2ls() {
    aws ec2 describe-instances --query "Reservations[*].Instances[*].[InstanceId,State.Name,InstanceType,PrivateIpAddress,PublicIpAddress,Tags[?Key==\`Name\`].Value|[0]]" --output table
}

ec2running() {
    aws ec2 describe-instances --filters "Name=instance-state-name,Values=running" --query "Reservations[*].Instances[*].[InstanceId,Tags[?Key==\`Name\`].Value|[0],PrivateIpAddress]" --output table
}

eksls() {
    aws eks list-clusters --query "clusters" --output table
}

eksupdate() {
    aws eks update-kubeconfig --name "$1"
}

ecrlogin() {
    aws ecr get-login-password | docker login --username AWS --password-stdin $(aws sts get-caller-identity --query Account --output text).dkr.ecr.$(aws configure get region).amazonaws.com
}

lambdals() {
    aws lambda list-functions --query "Functions[*].[FunctionName,Runtime,MemorySize]" --output table
}

s3tree() {
    aws s3 ls s3://"$1" --recursive | awk '{print $4}' | sed 's/[^\/]*$//' | sort -u
}

# Utility Functions
mkcd() {
    mkdir -p "$1" && cd "$1"
}

extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar e "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)           echo "'$1' cannot be extracted" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Base64 encode/decode
b64e() {
    echo -n "$1" | base64
}

b64d() {
    echo "$1" | base64 -d && echo ""
}

# URL encode/decode
urlencode() {
    python3 -c "import urllib.parse; print(urllib.parse.quote('$1'))"
}

urldecode() {
    python3 -c "import urllib.parse; print(urllib.parse.unquote('$1'))"
}

# Generate random password
genpass() {
    openssl rand -base64 "${1:-32}" | tr -d '=' | head -c "${1:-32}" && echo ""
}

# Kill process on port
killport() {
    lsof -ti:"$1" | xargs kill -9 2>/dev/null
}

# Find large files
largef() {
    find . -type f -size +"${1:-100M}" -exec ls -lh {} \; 2>/dev/null
}

# Directory sizes sorted
dirsizes() {
    du -sh */ 2>/dev/null | sort -h
}

# Git quick commit and push
gcap() {
    git add --all && git commit -m "$1" && git push
}

# Helm - quick install/upgrade
hui() {
    helm upgrade --install "$@"
}

# Show all custom aliases
customfuncs() {
    echo "Custom DevOps Functions:"
    echo ""
    echo "Kubernetes:"
    echo "  kln <partial>      - logs by partial pod name"
    echo "  kexn <partial>     - exec into pod by partial name"
    echo "  ksecdec <sec> <key> - decode secret value"
    echo "  ksecshow <secret>  - show all decoded secrets"
    echo "  kdebug             - run debug alpine pod"
    echo ""
    echo "Docker:"
    echo "  dsh <container>    - shell into container"
    echo "  dbash <container>  - bash into container"
    echo ""
    echo "AWS:"
    echo "  awswho             - get caller identity"
    echo "  ec2ls              - list EC2 instances"
    echo "  ec2running         - list running instances"
    echo "  eksls              - list EKS clusters"
    echo "  eksupdate <name>   - update kubeconfig"
    echo "  ecrlogin           - docker login to ECR"
    echo "  s3tree <bucket>    - show S3 bucket structure"
    echo ""
    echo "Utils:"
    echo "  mkcd <dir>         - mkdir and cd"
    echo "  extract <file>     - extract any archive"
    echo "  b64e/b64d          - base64 encode/decode"
    echo "  urlencode/urldecode - URL encode/decode"
    echo "  genpass [len]      - generate password"
    echo "  killport <port>    - kill process on port"
    echo "  largef [size]      - find large files"
    echo "  dirsizes           - directory sizes sorted"
    echo "  gcap <msg>         - git add, commit, push"
    echo ""
}

# =================================================
# ALIASES - PRODUCTIVITY
# =================================================

# Directory shortcuts
alias workspace='cd $WORKSPACE'
alias learn='cd $LEARNING_DIR'
alias platform='cd $PLATFORM_DIR'
alias downloads='cd ~/Downloads'
alias documents='cd ~/Documents'
alias desktop='cd ~/Desktop'

# Quick editing
alias zshrc='$EDITOR ~/.zshrc'
alias zshreload='source ~/.zshrc'
alias vimrc='$EDITOR ~/.vimrc'
alias gitconfig='$EDITOR ~/.gitconfig'

# Utilities
alias weather='curl -s "wttr.in?format=3"'
alias moon='curl -s "wttr.in/Moon"'
alias serve='httpserve'
alias uuid='uuidgen | tr "[:upper:]" "[:lower:]"'
alias timestamp='date +%s'
alias json='python3 -m json.tool'

# alias devops-ip='docker pull moabukar/devops-interview-prep:latest >/dev/null 2>&1 && docker run --platform linux/arm64 -it --rm moabukar/devops-interview-prep'

# =================================================
# EXPORTS FOR KUBECTL
# =================================================

export do="--dry-run=client -o yaml"
export now="--force --grace-period=0"

# =================================================
# POWERLEVEL10K CONFIGURATION
# =================================================

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# =================================================
# FINAL SETUP & WELCOME MESSAGE
# =================================================

# Create necessary directories
[[ ! -d "$WORKSPACE" ]] && mkdir -p "$WORKSPACE"
[[ ! -d "$LEARNING_DIR" ]] && mkdir -p "$LEARNING_DIR"
[[ ! -d "$PLATFORM_DIR" ]] && mkdir -p "$PLATFORM_DIR"

# ============================================================================
# Better CLI Tools
# ============================================================================
alias cat='bat --paging=never'
alias ls='eza --icons'
alias ll='eza -la --icons'
alias lt='eza --tree --icons'
alias top='btop'
alias du='dust'
alias ps='procs'
alias curl='http'

# ============================================================================
# Git Enhancements
# ============================================================================
alias lg='lazygit'
alias gd='git diff | diff-so-fancy | less -R'

# ============================================================================
# Security & Scanning
# ============================================================================
alias tf-scan='tfsec .'
alias container-scan='trivy image'
alias iac-scan='trivy config .'

# ============================================================================
# Kubernetes Enhancements
# ============================================================================
alias k9='k9s'
alias klogs='stern'
alias ktail='kubetail'

# ============================================================================
# Load Testing
# ============================================================================
alias loadtest='hey -z 10s -c 50'

# welcome message
echo "Engineer Shell Environment Loaded"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Type 'sysinfo' for system information"
echo "Type 'k8s-ctx' to see Kubernetes contexts"
echo "Type 'awswhoami' to check AWS identity"
echo "Type 'mpstatus' for Multipass VMs"
echo "Type 'aliases' to see custom functions"
echo "Edit config with 'zshrc'"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

### Testing

alias devops-dash='clear && echo "🚀 DevOps Dashboard" && echo "===================" && echo "📊 System:" && sysinfo && echo -e "\n☁️  AWS:" && awswhoami && echo -e "\n🐳 Docker:" && docker ps --format "table {{.Names}}\t{{.Status}}" && echo -e "\n🎯 Kubernetes:" && kubectl config current-context 2>/dev/null || echo "Not connected" && echo -e "\n🖥️  Multipass:" && multipass list 2>/dev/null || echo "Not available"'