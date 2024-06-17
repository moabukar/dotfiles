# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n] confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Colorls alias
if [ -x "$(command -v colorls)" ]; then
    alias ls="colorls"
    alias la="colorls -al"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Set name of the theme to load --- if set to "random", it will load a random theme each time oh-my-zsh is loaded, in which case, to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Kubernetes alias
alias k=kubectl
# complete -F __start_kubectl k
[[ /opt/homebrew/bin/kubectl ]] && source <(kubectl completion zsh)

# Homebrew initialization
eval "$(/opt/homebrew/bin/brew shellenv)"

# pyenv initialization (uncomment if using pyenv)
# export PYENV_ROOT="$HOME/.pyenv"
# export PATH="$PYENV_ROOT/bin:$PATH"
# if command -v pyenv 1>/dev/null 2>&1; then
#   eval "$(pyenv init -)"
# fi

# Go environment setup
if which go >/dev/null; then
  export GOPATH=$(go env GOPATH)
  export GOROOT=$(go env GOROOT)
  export GOBIN=$GOPATH/bin
  echo $PATH | grep -q $GOPATH/bin || export PATH=$GOPATH/bin:$PATH
  echo $PATH | grep -q $GOROOT/bin || export PATH=$GOROOT/bin:$PATH
fi

# Homebrew PATH setup
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

# Source Powerlevel10k theme
source ~/powerlevel10k/powerlevel10k.zsh-theme

### Custom AWS functions

function ec2lookup {
  cmd="aws --profile $1 ec2 describe-instances --filters \"Name=tag:Name,Values=$2\" --query 'Reservations[].Instances[].[InstanceId,PrivateIpAddress,State.Name,ImageId,join(\`,\`,Tags[?Key==\`Name\`].Value)]' --output ${3:-text}"
  if [ $# -eq 4 ]; then
    echo "Running $cmd"
  fi
  eval $cmd
}

function ec2lookup2() {
    if [ "$#" -lt 2 ]; then
        echo "Usage: ec2lookup <profile> <tag-value> [output-format]"
        return 1
    fi
    local profile=$1
    local tag_value=$2
    local output_format=${3:-text}
    aws --profile "$profile" ec2 describe-instances --filters "Name=tag:Name,Values=$tag_value" --query 'Reservations[].Instances[].[InstanceId,PrivateIpAddress,State.Name,ImageId,join(`,`,Tags[?Key==`Name`].Value)]' --output "$output_format"
}

function aws-roles-available {
  aws iam list-roles --query 'Roles[*].[Arn,RoleName]' --output table | grep -i "$(aws sts get-caller-identity | jq '.Arn' | cut -d '/' -f 2 | cut -d '_' -f 2)Admin\|\/$(aws sts get-caller-identity | jq '.Arn' | cut -d '/' -f 2 | cut -d '_' -f 2)\/"
}

### ALIASES

# General Linux
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'
alias .6='cd ../../../../../..'
alias c='clear'
alias csrgen='openssl req -out CSR.csr -new -newkey rsa:4096 -nodes -keyout privatekey.key'
alias myip='curl http://ipecho.net/plain; echo'
alias disk='df -h'
alias mem='free -m'
alias ps='ps aux'
alias hist='history | tail -n 100'


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
alias kf='kubectl create -f'
alias kg='kubectl get pods --show-labels'
alias kr='kubectl replace -f'
alias kh='kubectl --help | more'
alias kns='kubectl get namespaces'
alias l='ls -lrt'
alias ll='ls -rt | tail -1'
alias kga='k get pod --all-namespaces'
alias kgaa='kubectl get all --show-labels'
alias kgev='kubectl get events --sort-by='.metadata.creationTimestamp''
alias kdda='kubectl delete deployments --all --all-namespaces'
alias ksys='kubectl config view'

## Argo

# alias getargoip='kubectl get svc argocd-server -n argocd -o jsonpath='{.spec.clusterIP}''

alias argoip="kubectl get svc argocd-server -n argocd -o jsonpath='{.spec.clusterIP}'"
alias argopass="kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath='{.data.password}' | base64 --decode"

# Helm
alias hdda='helm list --all-namespaces -q | while read -r release; do helm uninstall "$release" --namespace "$(helm list --all-namespaces | grep "$release" | awk '{print $2}')" ; done'
alias hlsns='helm ls --all-namespaces'
alias h='helm'
alias hin='helm install'
alias hup='helm upgrade'
alias hdel='helm delete'
alias hlst='helm list'
alias hrepo='helm repo'
alias hrepoupd='helm repo update'
alias hdepupd='helm dependency update'


# Terraform
alias tfmt='terraform fmt --recursive'
alias tf='terraform'
alias tfi='terraform init'
alias tfp='terraform plan'
alias tfa='terraform apply'
alias tfinv='terraform state list'
alias tfd='terraform destroy'
alias tfve='terraform version'
alias tfva='terraform validate'
alias tfa!='terraform apply --auto-approve'
alias tfd!='terraform destroy --auto-approve'

# Docker
alias d='docker'
alias dc='docker-compose'
alias dcl='docker container ls'
alias di='docker image ls'
alias de='docker exec -it'
alias dpsa='docker ps -a'
alias dps='docker ps'
alias dlogs='docker logs'
alias dexec='docker exec -it'
alias drm='docker rm -f $(docker ps -a -q)'
alias dip='docker image prune -a'
alias dprune='docker system prune -f'
alias traefik-start='traefik --configfile=./static.yml'
alias reload='source ~/.zshrc'


# AWS
alias aws-who='aws sts get-caller-identity'

# Git
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

# Brew (when Brew bugs out on macOS)
alias brew='arch -x86_64 brew'
alias binstall='arch -x86_64 brew install'

# Root location for learning & playground
alias learn='cd ~/Documents/Learning'

## Change `team_name` to when new company is joined
alias team_name='cd ~/Documents/team_name'


# Ansible aliases
alias a='ansible'
alias ap='ansible-playbook'
alias av='ansible-vault'
alias ag='ansible-galaxy'
alias ainv='ansible-inventory'
alias al='ansible-lint'

# General aliases
alias e='exit'
alias vi='vim'
alias h='history'
alias p='ps aux'
alias t='tail -f'
alias r='source ~/.zshrc'
alias home="cd $HOME"

# Logging and monitoring
alias l='less'
alias tlog='tail -f /var/log/syslog'
alias j='journalctl -xe'
alias topcpu='ps aux --sort=-%cpu | head'
alias topmem='ps aux --sort=-%mem | head'

# Networking
alias getip='curl http://checkip.amazonaws.com/'
alias ipl='ip addr show'
alias ipt='iptables'
alias pscan='nmap -sn'
alias lsof='lsof -i'

# Dev tools
alias run-redis='docker run --rm -d --name  redis -p 127.0.0.1:6379:6379 redis'
alias run-nginx='docker run --rm -d --name nginx -p 127.0.0.1:8080:80 nginx'
alias run-mysql='docker run --rm -d --name mysql -e MYSQL_ROOT_PASSWORD=root -e MYSQL_DATABASE=testdb -p 127.0.0.1:3306:3306 mysql:5.7'
alias run-postgres='docker run --rm -d --name postgres -e POSTGRES_PASSWORD=root -e POSTGRES_DB=testdb -p 127.0.0.1:5432:5432 postgres'
alias run-mongo='docker run --rm -d --name mongo -p 127.0.0.1:27017:27017 mongo'
alias run-rabbitmq='docker run --rm -d --name rabbitmq -p 127.0.0.1:5672:5672 -p 127.0.0.1:15672:15672 rabbitmq:3-management'
alias run-elasticsearch='docker run --rm -d --name elasticsearch -p 127.0.0.1:9200:9200 -e "discovery.type=single-node" elasticsearch:7.10.1'
alias run-kibana='docker run --rm -d --name kibana -p 127.0.0.1:5601:5601 kibana:7.10.1'
alias run-grafana='docker run --rm -d --name grafana -p 127.0.0.1:3000:3000 grafana/grafana'
alias run-prometheus='docker run --rm -d --name prometheus -p 127.0.0.1:9090:9090 prom/prometheus'
alias run-jenkins='docker run --rm -d --name jenkins -p 127.0.0.1:8080:8080 -p 127.0.0.1:50000:50000 jenkins/jenkins:lts'
alias rl='npm run local'

## Docker functions
BASE_DIR=$HOME/docker
DEFAULT_ROOT_PWD=mypassword

# function d_mysql_run() {
#     docker run --rm --name mysql5.7-docker -d \
#     -p 127.0.0.1:3306:3306 \
#     -v $BASE_DIR/mysql5.7:/var/lib/mysql \
#     -e MYSQL_ROOT_PASSWORD=$DEFAULT_ROOT_PWD \
#     mysql:5.7
# }

# function start_psql_container() {
#     docker run --name posgres12 -d \
#     -e POSTGRES_PASSWORD=$DEFAULT_ROOT_PWD \
#     -e POSTGRES_USER=root \
#     -p 5432:5432 \
#     postgres:12-alpine
# }

# Zsh plugins
# plugins=(
#   docker
#   docker-compose
#   git
#   golang
#   kubectl
#   macos 
#   rust 
#   terraform
#   tmux
#   zsh-syntax-highlighting
# )

source ~/powerlevel10k/powerlevel10k.zsh-theme

# # Source the Zsh completion
# autoload -U compinit
# compinit

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/mohameda/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
