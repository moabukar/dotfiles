#!/bin/bash
# ~/.bashrc - Principal DevOps Engineer Configuration (Bash)
# ==========================================================
# Ported from .zshrc for Linux/Ubuntu systems without Zsh
# ==========================================================

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# ==========================================================
# ENVIRONMENT VARIABLES
# ==========================================================

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export EDITOR='vim'
export VISUAL='vim'
export ARCHFLAGS="-arch $(uname -m)"

# Development directories
export WORKSPACE="$HOME/workspace"
export LEARNING_DIR="$HOME/Documents/Learning"
export PLATFORM_DIR="$HOME/Documents/Platform"

# Tool-specific
export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1

# Kubectl shortcuts
export do="--dry-run=client -o yaml"
export now="--force --grace-period=0"

# ==========================================================
# HISTORY CONFIGURATION
# ==========================================================

HISTCONTROL=ignoreboth:erasedups
HISTSIZE=50000
HISTFILESIZE=50000
HISTTIMEFORMAT="%F %T  "
shopt -s histappend
shopt -s cmdhist

# ==========================================================
# SHELL OPTIONS
# ==========================================================

shopt -s checkwinsize
shopt -s cdspell
shopt -s dirspell 2>/dev/null
shopt -s autocd 2>/dev/null
shopt -s globstar 2>/dev/null
shopt -s nocaseglob

# ==========================================================
# PATH CONFIGURATION
# ==========================================================

export PATH="$HOME/.local/bin:$HOME/bin:$PATH"
export PATH="$HOME/.rd/bin:$PATH"

# ==========================================================
# PROMPT
# ==========================================================

force_color_prompt=yes

if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    PS1='\[\033[01;32m\]\u\[\033[01;33m\]@\[\033[01;36m\]\h \[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='\u@\h:\w\$ '
fi

# Git branch in prompt (if git is available)
parse_git_branch() {
    git symbolic-ref --short HEAD 2>/dev/null
}

if command -v git >/dev/null 2>&1; then
    PS1='\[\033[01;32m\]\u\[\033[01;33m\]@\[\033[01;36m\]\h \[\033[01;34m\]\w\[\033[01;35m\]$(parse_git_branch 2>/dev/null | sed "s/^/ /")\[\033[00m\]\$ '
fi

# ==========================================================
# COMPLETION
# ==========================================================

if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# kubectl completion
if command -v kubectl >/dev/null 2>&1; then
    source <(kubectl completion bash)
    complete -F __start_kubectl k
fi

# helm completion
if command -v helm >/dev/null 2>&1; then
    source <(helm completion bash)
fi

# ==========================================================
# COLOR SUPPORT
# ==========================================================

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# ==========================================================
# ALIASES - NAVIGATION & BASICS
# ==========================================================

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ~='cd ~'
alias -- -='cd -'

alias c='clear'
alias h='history'
alias j='jobs -l'
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%T"'
alias nowdate='date +"%d-%m-%Y"'
alias reload='source ~/.bashrc'

# ls
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# File operations (safe)
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -iv'
alias mkdir='mkdir -pv'

# System
alias df='df -H'
alias du='du -ch'
alias free='free -mt'
alias psg='ps aux | grep -v grep | grep -i -e VSZ -e'
alias myip='curl -s http://ipecho.net/plain; echo'
alias speedtest='curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python3 -'

# Network
alias ping='ping -c 5'
alias ports='ss -tulpn'
alias listening='ss -tulpn | grep LISTEN'

# ==========================================================
# ALIASES - GIT
# ==========================================================

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

# ==========================================================
# ALIASES - KUBERNETES
# ==========================================================

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

# Describe
alias kd='kubectl describe'
alias kdp='kubectl describe pod'
alias kds='kubectl describe service'
alias kdd='kubectl describe deployment'
alias kdn='kubectl describe node'

# Edit
alias ke='kubectl edit'
alias kep='kubectl edit pod'
alias kes='kubectl edit service'
alias ked='kubectl edit deployment'

# Delete
alias kdel='kubectl delete'
alias kdelp='kubectl delete pod'
alias kdels='kubectl delete service'
alias kdeld='kubectl delete deployment'

# Logs and exec
alias kl='kubectl logs'
alias klf='kubectl logs -f'
alias kexec='kubectl exec -it'
alias kpf='kubectl port-forward'

# Context/namespace (kubectx/kubens if available)
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

# ==========================================================
# ALIASES - DOCKER
# ==========================================================

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

# ==========================================================
# ALIASES - TERRAFORM & TERRAGRUNT
# ==========================================================

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

alias tg='terragrunt'
alias tgi='terragrunt init'
alias tgp='terragrunt plan'
alias tga='terragrunt apply'
alias tgd='terragrunt destroy'
alias tgf='terragrunt fmt'
alias tgv='terragrunt validate'
alias tgo='terragrunt output'

alias tgrai='terragrunt run-all init'
alias tgrap='terragrunt run-all plan'
alias tgraa='terragrunt run-all apply'
alias tgrad='terragrunt run-all destroy'
alias tgrav='terragrunt run-all validate'

# ==========================================================
# ALIASES - HELM
# ==========================================================

alias hl='helm list'
alias hla='helm list --all-namespaces'
alias hi='helm install'
alias hu='helm upgrade'
alias hd='helm delete'
alias hs='helm search'
alias hsr='helm search repo'
alias hr='helm repo'
alias hra='helm repo add'
alias hru='helm repo update'
alias hrl='helm repo list'
alias hv='helm version'
alias hh='helm history'

# ==========================================================
# ALIASES - ANSIBLE
# ==========================================================

alias a='ansible'
alias ap='ansible-playbook'
alias av='ansible-vault'
alias ag='ansible-galaxy'
alias ai='ansible-inventory'
alias ac='ansible-config'
alias ad='ansible-doc'

# ==========================================================
# ALIASES - AWS
# ==========================================================

alias awsp='awsprofile'
alias awsw='awswhoami'
alias ec2='aws ec2'
alias s3='aws s3'
alias iam='aws iam'
alias cf='aws cloudformation'
alias ssm='aws ssm'

# ==========================================================
# ALIASES - SECURITY & SCANNING
# ==========================================================

alias tf-scan='tfsec .'
alias container-scan='trivy image'
alias iac-scan='trivy config .'
alias checkov-scan='checkov -d .'

# ==========================================================
# ALIASES - PRODUCTIVITY
# ==========================================================

alias workspace='cd $WORKSPACE'
alias learn='cd $LEARNING_DIR'
alias platform='cd $PLATFORM_DIR'
alias downloads='cd ~/Downloads'
alias documents='cd ~/Documents'
alias desktop='cd ~/Desktop'

alias bashrc='$EDITOR ~/.bashrc'
alias vimrc='$EDITOR ~/.vimrc'
alias gitconfig='$EDITOR ~/.gitconfig'
alias weather='curl -s "wttr.in?format=3"'
alias moon='curl -s "wttr.in/Moon"'
alias uuid='uuidgen | tr "[:upper:]" "[:lower:]"'
alias timestamp='date +%s'
alias json='python3 -m json.tool'

# ==========================================================
# CUSTOM FUNCTIONS
# ==========================================================

# System info
sysinfo() {
    echo "System Information"
    echo "========================="
    echo "OS: $(uname -s) $(uname -r)"
    echo "Shell: $SHELL"
    echo "User: $(whoami)"
    echo "Hostname: $(hostname)"
    echo "Uptime: $(uptime -p 2>/dev/null || uptime | sed 's/.*up \([^,]*\),.*/\1/')"
    if command -v free >/dev/null 2>&1; then
        echo "Memory: $(free -h | awk '/^Mem:/ {print $3 "/" $2}')"
    fi
    echo "Disk Usage: $(df -h / | tail -1 | awk '{print $3 "/" $2 " (" $5 ")"}')"
    echo "Load Average: $(uptime | awk -F'load average:' '{print $2}' | sed 's/^[ \t]*//')"
}

# File/dir search
ff() {
    if [[ $# -eq 0 ]]; then echo "Usage: ff <pattern> [directory]"; return 1; fi
    find "${2:-.}" -type f -name "*$1*" 2>/dev/null | head -20
}

fd() {
    if [[ $# -eq 0 ]]; then echo "Usage: fd <pattern> [directory]"; return 1; fi
    find "${2:-.}" -type d -name "*$1*" 2>/dev/null | head -20
}

# Git utilities
gitpushup() {
    local branch
    branch=$(git symbolic-ref --short HEAD 2>/dev/null)
    if [[ -n "$branch" ]]; then
        echo "Pushing $branch and setting upstream..."
        git push --set-upstream origin "$branch"
    else
        echo "Not in a git repository or no current branch"
        return 1
    fi
}

git_status_all() {
    for dir in */; do
        if [[ -d "$dir/.git" ]]; then
            echo "$dir"
            (cd "$dir" && git status --porcelain)
            echo
        fi
    done
}

gcap() {
    git add --all && git commit -m "$1" && git push
}

# AWS utilities
awsprofile() {
    if [[ $# -eq 0 ]]; then
        echo "Current AWS Profile: ${AWS_PROFILE:-default}"
        echo "Available profiles:"
        aws configure list-profiles 2>/dev/null || echo "No profiles found"
    else
        export AWS_PROFILE="$1"
        echo "AWS Profile set to: $1"
    fi
}

awswhoami() {
    echo "Current AWS Identity:"
    aws sts get-caller-identity 2>/dev/null || echo "Not authenticated or AWS CLI not configured"
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
    aws ecr get-login-password | docker login --username AWS --password-stdin "$(aws sts get-caller-identity --query Account --output text).dkr.ecr.$(aws configure get region).amazonaws.com"
}

s3tree() {
    aws s3 ls "s3://$1" --recursive | awk '{print $4}' | sed 's/[^\/]*$//' | sort -u
}

# Kubernetes utilities
kln() {
    kubectl logs -f "$(kubectl get pods | grep "$1" | head -1 | awk '{print $1}')"
}

kexn() {
    kubectl exec -it "$(kubectl get pods | grep "$1" | head -1 | awk '{print $1}')" -- /bin/sh
}

kbashexn() {
    kubectl exec -it "$(kubectl get pods | grep "$1" | head -1 | awk '{print $1}')" -- /bin/bash
}

ksecdec() {
    kubectl get secret "$1" -o jsonpath="{.data.$2}" | base64 -d
}

ksecshow() {
    kubectl get secret "$1" -o json | jq -r '.data | to_entries[] | "\(.key): \(.value | @base64d)"'
}

kdebug() {
    kubectl run debug-pod --rm -it --image=alpine -- /bin/sh
}

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
    kubectl get pods --all-namespaces -o wide
}

k8s-events() {
    kubectl get events --sort-by='.lastTimestamp' | tail -20
}

# Docker utilities
dsh() { docker exec -it "$1" /bin/sh; }
dbash() { docker exec -it "$1" /bin/bash; }

docker-cleanup() {
    read -p "This will remove all stopped containers, unused networks, images, and build cache. Continue? (y/N) " confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        docker system prune -af
        docker volume prune -f
        echo "Docker cleanup complete"
    else
        echo "Cleanup cancelled"
    fi
}

docker-stats() {
    echo "Docker System Usage:"
    docker system df
    echo ""
    echo "Running Containers:"
    docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"
}

# Terraform utilities
tf-clean() {
    find . -type d -name ".terraform" -exec rm -rf {} + 2>/dev/null
    find . -type f -name ".terraform.lock.hcl" -delete 2>/dev/null
    find . -type f -name "terraform.tfstate.backup" -delete 2>/dev/null
    echo "Terraform cache cleaned"
}

tg-clean() {
    find . -type d -name ".terragrunt-cache" -exec rm -rf {} + 2>/dev/null
    echo "Terragrunt cache cleaned"
}

# Quick services
run-redis() {
    docker run --rm -d --name redis -p 127.0.0.1:6379:6379 redis:alpine
    echo "Redis started on localhost:6379"
}

run-postgres() {
    docker run --rm -d --name postgres \
        -e POSTGRES_PASSWORD=password \
        -e POSTGRES_DB=testdb \
        -p 127.0.0.1:5432:5432 postgres:15-alpine
    echo "PostgreSQL started on localhost:5432 (user: postgres, password: password, db: testdb)"
}

run-mysql() {
    docker run --rm -d --name mysql \
        -e MYSQL_ROOT_PASSWORD=password \
        -e MYSQL_DATABASE=testdb \
        -p 127.0.0.1:3306:3306 mysql:8.0
    echo "MySQL started on localhost:3306 (user: root, password: password, db: testdb)"
}

# Dev utilities
httpserve() {
    local port="${1:-8000}"
    echo "Starting HTTP server on port $port..."
    python3 -m http.server "$port"
}

mkcd() { mkdir -p "$1" && cd "$1"; }

extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2) tar xjf "$1" ;;
            *.tar.gz)  tar xzf "$1" ;;
            *.bz2)     bunzip2 "$1" ;;
            *.rar)     unrar e "$1" ;;
            *.gz)      gunzip "$1" ;;
            *.tar)     tar xf "$1" ;;
            *.tbz2)    tar xjf "$1" ;;
            *.tgz)     tar xzf "$1" ;;
            *.zip)     unzip "$1" ;;
            *.Z)       uncompress "$1" ;;
            *.7z)      7z x "$1" ;;
            *) echo "'$1' cannot be extracted" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

b64e() { echo -n "$1" | base64; }
b64d() { echo "$1" | base64 -d && echo ""; }

genpass() { openssl rand -base64 "${1:-32}" | tr -d '=' | head -c "${1:-32}" && echo ""; }

killport() { lsof -ti:"$1" | xargs kill -9 2>/dev/null; }

largef() { find . -type f -size +"${1:-100M}" -exec ls -lh {} \; 2>/dev/null; }

dirsizes() { du -sh */ 2>/dev/null | sort -h; }

hui() { helm upgrade --install "$@"; }

# Help function
aliases() {
    echo "DevOps Custom Functions & Aliases"
    echo "=========================================="
    echo ""
    echo "Kubernetes:"
    echo "  kln <partial>       - logs by partial pod name"
    echo "  kexn <partial>      - exec into pod"
    echo "  ksecdec <sec> <key> - decode secret"
    echo "  ksecshow <secret>   - show all decoded secrets"
    echo "  kdebug              - run debug pod"
    echo "  k8s-ctx             - show k8s contexts"
    echo "  k8s-ns              - show namespaces"
    echo ""
    echo "Docker:"
    echo "  dsh <container>     - shell into container"
    echo "  dbash <container>   - bash into container"
    echo "  docker-cleanup      - prune everything"
    echo "  docker-stats        - show usage stats"
    echo ""
    echo "AWS:"
    echo "  awswho              - show AWS identity"
    echo "  ec2ls               - list EC2 instances"
    echo "  eksls               - list EKS clusters"
    echo "  ecrlogin            - docker login to ECR"
    echo "  s3tree <bucket>     - show bucket structure"
    echo ""
    echo "Services:"
    echo "  run-redis           - start Redis container"
    echo "  run-postgres        - start PostgreSQL container"
    echo "  run-mysql           - start MySQL container"
    echo ""
    echo "Utils:"
    echo "  sysinfo             - system information"
    echo "  mkcd <dir>          - mkdir and cd"
    echo "  extract <file>      - extract any archive"
    echo "  b64e/b64d           - base64 encode/decode"
    echo "  genpass [len]       - generate password"
    echo "  killport <port>     - kill process on port"
    echo "  gcap <msg>          - git add, commit, push"
    echo "  ff/fd <pattern>     - find files/dirs"
    echo "  largef [size]       - find large files"
    echo "  dirsizes            - directory sizes sorted"
    echo "  httpserve [port]    - start HTTP server"
    echo ""
    echo "Security:"
    echo "  tf-scan             - scan terraform with tfsec"
    echo "  container-scan      - scan image with trivy"
    echo "  iac-scan            - scan IaC with trivy"
    echo ""
}

# ==========================================================
# TOOL ENVIRONMENT SETUP
# ==========================================================

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Go
if command -v go >/dev/null 2>&1; then
    export GOPATH="$(go env GOPATH)"
    export GOBIN="$GOPATH/bin"
    export PATH="$GOBIN:$PATH"
fi

# pyenv
if command -v pyenv >/dev/null 2>&1; then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
fi

# Cargo/Rust
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# Create workspace directories
[[ ! -d "$WORKSPACE" ]] && mkdir -p "$WORKSPACE"

# ==========================================================
# WELCOME
# ==========================================================

echo "Engineer Shell Environment Loaded (bash)"
echo "=========================================="
echo "Type 'sysinfo' for system information"
echo "Type 'aliases' to see custom functions"
echo "Edit config with 'bashrc'"
echo "=========================================="
