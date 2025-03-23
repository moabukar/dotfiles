# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export PATH=$PATH:/opt/homebrew/bin

# autoload -U bashcompinit
# bashcompinit

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

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
# source ~/powerlevel10k/powerlevel10k.zsh-theme

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
alias ls="eza --icons=always"
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
alias psaux='ps aux | grep'
alias hist='history | tail -n 100'

# K8s

# Kubernetes alias
# alias k=kubecolor
# alias kubectl="kubecolor"
complete -F __start_kubectl k
[[ /opt/homebrew/bin/kubectl ]] && source <(kubectl completion zsh)
source <(kubectl completion zsh)
autoload -Uz compinit
compinit

alias gitcron='sh /Users/mohameda/Documents/learning/github-cron/scripts/github_cron.sh'


alias k='kubectl' ## alias above already
alias kx='kubectx'
alias kg='kubectl get'
alias ke='kubectl edit'
alias kd='kubectl describe'
alias kdd='kubectl delete'
alias kgp='kubectl get pods'
alias kgd='kubectl get deployments'
alias kgs='kubectl get service'
alias kgsec='kubectl get secret -o yaml'
alias kseca='kubectl get secret --all-namespaces'
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
alias kcm='kubectl get configmaps'
alias l='ls -lrt'
alias ll='ls -rt | tail -1'
alias kga='k get pod --all-namespaces'
alias kgaa='kubectl get all --show-labels'
alias kgev='kubectl get events --sort-by='.metadata.creationTimestamp''
alias kdda='kubectl delete deployments --all --all-namespaces'
alias ksys='kubectl config view'
alias kexec='kubectl exec -it'
alias kgsvc='kubectl get svc -o wide'
alias kgn='kubectl get no -o wide'
alias kpf='kubectl port-forward'
alias kd='kubectl describe'
alias krr='kubectl rollout restart'
alias ksysgpo='kubectl --namespace=kube-system get pods'
alias ksysdpo='kubectl --namespace=kube-system describe pods'
alias ksysgpow='kubectl --namespace=kube-system get pods --watch'
alias kgall='kubectl get --all-namespaces'
alias podrange="kubectl get nodes -o jsonpath='{.items[*].spec.podCIDR}'"
alias nodeips='k get nodes -o custom-columns=NODE:.metadata.name,POD_CIDR:.spec.podCIDR'
alias rd="kubectx rancher-desktop"
alias dd="kubectx docker-desktop"
export do="--dry-run=client -o yaml"

# export d="--dry-run=client"



alias do="--dry-run=client -o yaml"

alias now="--force --grace-period=0"

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
alias tgfmt='terragrunt hclfmt'

# Docker
alias d='docker'
alias dc='docker compose'
alias dcl='docker container ls'
alias di='docker image ls'
alias de='docker exec -it'
alias dpsa='docker ps -a'
alias dps='docker ps'
alias dlogs='docker logs'
alias dexec='docker exec -it'
# alias drm='docker rm -f $(docker ps -a -q)'
alias drm='docker ps -a -q | xargs -r docker rm -f'
alias dip='docker image prune -af'
alias dprune='docker system prune -af'
alias dnp='docker network prune -f'
alias traefik-start='traefik --configfile=./static.yml'
alias reload='source ~/.zshrc'


# AWS
alias aws-who='aws sts get-caller-identity'

# Git
alias gi='git init'
alias gs='git status'
alias gcl='git clone'
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
#alias binstall='arch -x86_64 brew install'
alias binstall='arch -arm64 brew install'
alias brew='arch -arm64 brew'


# Root location for learning & playground
alias learn='cd ~/Documents/Learning'

## Change `team_name` to when new company is joined (or wherever your work dir is located)
alias platform='cd ~/Documents/Platform'


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

alias zt='zerotier-cli'

## Vault
export VAULT_ADDR='http://127.0.0.1:8200'
alias vault-start="vault server -dev"

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

## multipass
alias mp='multipass'
alias mpl='multipass list'
alias mpd='multipass delete --all'
alias mpp='multipass purge'
alias mps='multipass shell'

# Dev tools
alias run-redis='docker run --rm -d --name  redis -p 127.0.0.1:6379:6379 redis'
alias run-nginx='docker run --rm -d --name nginx -p 127.0.0.1:8080:80 nginx'
alias run-apache='docker run --rm -d --name apache -p 127.0.0.1:8082:80 apache'
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
alias kind-init='kind create cluster --name kind-cluster --config <(cat <<EOF
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
- role: worker
- role: worker
EOF
)'
alias kind-delete='kind delete cluster --name kind-cluster'


## Docker functions
BASE_DIR=$HOME/docker
DEFAULT_ROOT_PWD=mypassword
### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/mohameda/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

# Created by `pipx` on 2024-11-18 17:31:36
export PATH="$PATH:/Users/mohameda/.local/bin"

function gitpushup() {
  current_branch=$(git symbolic-ref --short HEAD)
  git push --set-upstream origin "$current_branch"
}export PATH="/usr/local/bin:$PATH"
export PATH="/usr/local/bin:$PATH"


export PATH=$PATH:/Applications/UTM.app/Contents/MacOS/

export NVM_DIR=~/.nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion