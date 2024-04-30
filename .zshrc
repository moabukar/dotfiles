# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [ -x "$(command -v colorls)" ]; then
    alias ls="colorls"
    alias la="colorls -al"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
alias k=kubectl
complete -F __start_kubectl k
alias k=kubectl
complete -F __start_kubectl k
[[ /opt/homebrew/bin/kubectl ]] && source <(kubectl completion zsh)

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi
‘source /dev/fd/14’

# Go
if which go >/dev/null; then
  export GOPATH=$(go env GOPATH)
  export GOROOT=$(go env GOROOT)
  export GOBIN=$GOPATH/bin
  echo $PATH | grep -q $GOPATH/bin || export PATH=$GOPATH/bin:$PATH
  echo $PATH | grep -q $GOROOT/bin || export PATH=$GOROOT/bin:$PATH
fi

# Homebrew
if command -v brew >/dev/null; then
  BREWSBIN=/usr/local/sbin
  BREWBIN=/usr/local/bin
  echo $PATH | grep -q $BREWSBIN || export PATH=$BREWSBIN:$PATH
  echo $PATH | grep -q $BREWBIN || export PATH=$BREWBIN:$PATH
fi

# Load custom functions
if [[ -f "$HOME/workspace/dotfiles/zsh_functions.inc" ]]; then
	source "$HOME/workspace/dotfiles/zsh_functions.inc"
else
	echo >&2 "WARNING: can't load shell functions"
fi

source ~/powerlevel10k/powerlevel10k.zsh-theme

### Custom AWS funcs

function ec2lookup {
  cmd="aws --profile $1 ec2 describe-instances --filters \"Name=tag:Name,Values=$2\" --query 'Reservations[].Instances[].[InstanceId,PrivateIpAddress,State.Name,ImageId,join(\`,\`,Tags[?Key==\`Name\`].Value)]' --output ${3:-text}"
  if [ $# -eq 4 ]
  then
    echo "Running $cmd"
  fi
  eval $cmd
}

## list AWS roles ##
function aws-roles-available {
    aws iam list-roles --query 'Roles[*].[Arn,RoleName]' --output table  | grep -i "`aws sts get-caller-identity | jq '.Arn' | cut -d '/' -f 2 | cut -d '_' -f 2`Admin\|\/`aws sts get-caller-identity | jq '.Arn' | cut -d '/' -f 2 | cut -d '_' -f 2`\/"
}


### ALIASES

## General Linux

alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'
alias .6='cd ../../../../../..'
alias c='clear'
alias csrgen='openssl req -out CSR.csr -new -newkey rsa:4096 -nodes -keyout privatekey.key'
alias myip='curl http://ipecho.net/plain; echo'

# K8s
alias k='kubectl'
alias kg='kubectl get'
alias ke='kubectl edit'
alias kd='kubectl describe'
alias kdd='kubectl delete'
alias kgp='kubectl get pods'
alias kgd='kubectl get deployments'
alias kns='kubens'
alias kcx='kubectx'
alias wkgp='watch kubectl get pod'
alias kdp='kubectl describe pod'
alias krh='kubectl run --help | more'
alias ugh='kubectl get --help | more'
alias c='clear'
alias kd='kubectl describe pod'
alias ke='kubectl explain'
alias kf='kubectl create -f'
alias kg='kubectl get pods --show-labels'
alias kr='kubectl replace -f'
alias kh='kubectl --help | more'
alias krh='kubectl run --help | more'
alias ks='kubectl get namespaces'
alias l='ls -lrt'
alias ll='vi ls -rt | tail -1'
alias kga='k get pod --all-namespaces'
alias kgaa='kubectl get all --show-labels'
alias kgev='kubectl get events --sort-by=‘.metadata.creationTimestamp’'
alias kdda='kubectl delete deployments --all --all-namespaces'

#Helm
alias hdda='helm list --all-namespaces -q | while read -r release; do helm uninstall "$release" --namespace "$(helm list --all-namespaces | grep "$release" | awk '{print $2}')" ; done'


# Allow kubectl completion to use alias
complete -F __start_kubectl k

## Terraform
alias tfmt='terraform fmt --recursive'
alias tf='terraform'
alias tfi='terraform init'
alias tfp='terraform plan'
alias tfa='terraform apply'
alias tfd='terraform destroy'
alias tfve='terraform version'
alias tfva='terraform validate'
alias tfa!='terraform apply --auto-approve'
alias tfd!='terraform destroy --auto-approve'

# some docker and random ones
alias dc='docker-compose'
alias dcl='docker container ls'
alias de='docker exec -it'
alias dps='docker ps'

alias drm='docker rm -f $(docker ps -a -q)'
alias dip='docker image prune -a'
alias traefik-start='traefik --configfile=./static.yml'

alias aws-who='aws sts get-caller-identity'

alias learn='cd ~/Documents/Learning'

alias atlas='cd ~/Documents/Atlas'

alias gmd='go mod tidy'

## Git

alias gs='git status'
alias ga='git add'
alias gb='git branch'
alias gco='git checkout'
alias gcob='git checkout -b'
alias gcm='git commit -m'
alias gcam='git commit -am'
alias gl='git log'
alias gp='git pull'
alias gps='git push'


# AWS
alias aws-who='aws sts get-caller-identity'


## Docker
alias dc='docker-compose'

alias drm='docker rm -f $(docker ps -a -q)'
alias dip='docker image prune -a'

## Brew (when Brew bugs out on macOS)
alias brew='arch -x86_64 brew'
## Brew install shortcut (used for macOS Sonoma)
alias binstall='arch -x86_64 brew install'

# Root location for learning & playground
alias learn='cd ~/Documents/Learning'

## Change `team_name` to when new company is joined
alias team_name='cd ~/Documents/team_name'


# Docker

alias d='docker'
alias di='docker images'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias drm='docker rm'
alias drmi='docker rmi'
alias dlogs='docker logs'
alias dexec='docker exec -it'

# Ansible

alias a='ansible'
alias ap='ansible-playbook'
alias av='ansible-vault'
alias ag='ansible-galaxy'
alias ainv='ansible-inventory'
alias al='ansible-lint'

# General

alias c='clear'
alias e='exit'
alias vi='vim'
alias h='history'
alias p='ps aux'
alias t='tail -f'
alias r='source ~/.zshrc'
alias home="cd $HOME"
alias d="docker"
alias k="kubectl"

# Logging and monitoring

alias l='less'
alias tlog='tail -f /var/log/syslog'
alias j='journalctl -xe'
alias topcpu='ps aux --sort=-%cpu | head'
alias topmem='ps aux --sort=-%mem | head'\

# Networking

alias ipl='ip addr show'
alias ipt='iptables'
alias pscan='nmap -sn'
alias lsof='lsof -i'

# Dev tools

alias run-redis='docker run --rm -d --name  redis -p 127.0.0.1:6379:6379 redis'
alias rl='npm run local'

## Functions

BASE_DIR=$HOME/docker
DEFAULT_ROOT_PWD=mypassword

function d_mysql_run() {
    docker run --rm --name mysql5.7-docker -d \
    -p 127.0.0.1:3306:3306 \
    -v $BASE_DIR/mysql5.7:/var/lib/mysql \
    -e MYSQL_ROOT_PASSWORD=$DEFAULT_ROOT_PWD \
    mysql:5.7
}

function start_psql_container() {
    docker run --name posgres12 -d \
    -e POSTGRES_PASSWORD=$DEFAULT_ROOT_PWD \
    -e POSTGRES_USER=root \
    -p 5432:5432 \
    postgres:12-alpine
}

plugins=(
  docker
  docker-compose
  git
  golang
  kubectl
  macos 
  rust 
  terraform
  tmux
  zsh-syntax-highlighting
)
