# alma-wsl/aliases.zsh
# Daily shortcuts. Sourced by alma-wsl/.zshrc.

# ---------------------------------------------------------------------------
# Navigation
# ---------------------------------------------------------------------------
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias -- -='cd -'

# ---------------------------------------------------------------------------
# Shell basics
# ---------------------------------------------------------------------------
alias c='clear'
alias h='history'
alias path='echo -e ${PATH//:/\\n}'
alias reload='source ~/.zshrc'
alias zshrc='${EDITOR:-vim} ~/.zshrc'
alias aliases='${EDITOR:-vim} ~/code/dotfiles/alma-wsl/aliases.zsh'

# ---------------------------------------------------------------------------
# ls / file ops
# ---------------------------------------------------------------------------
alias ll='ls -lah --color=auto'
alias la='ls -A --color=auto'
alias l='ls -CF --color=auto'
alias lt='ls -lhtr --color=auto'   # sort by time, oldest last
alias cp='cp -iv'
alias mv='mv -iv'
alias mkdir='mkdir -pv'

# ---------------------------------------------------------------------------
# System
# ---------------------------------------------------------------------------
alias df='df -h'
alias du='du -ch'
alias free='free -mt'
alias psg='ps aux | grep -v grep | grep -i'
alias ports='ss -tulpn'
alias listening='ss -tlnp'
alias myip='curl -s https://ifconfig.me; echo'
alias ip='ip -c'

# ---------------------------------------------------------------------------
# Git — the ones you'll use every day
# ---------------------------------------------------------------------------
alias g='git'
alias gs='git status'
alias gss='git status -sb'
alias ga='git add'
alias gaa='git add -A'
alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit --amend'
alias gcane='git commit --amend --no-edit'
alias gco='git checkout'
alias gcob='git checkout -b'
alias gsw='git switch'
alias gswc='git switch -c'
alias gb='git branch'
alias gbd='git branch -d'
alias gbD='git branch -D'
alias gp='git pull'
alias gpr='git pull --rebase'
alias gps='git push'
alias gpsf='git push --force-with-lease'
alias gpsu='git push -u origin HEAD'
alias gl='git log --oneline -15'
alias gll='git log --graph --pretty=format:"%C(auto)%h%d %s %C(green)(%cr) %C(blue)<%an>%Creset" --abbrev-commit -30'
alias gd='git diff'
alias gds='git diff --staged'
alias gst='git stash'
alias gstp='git stash pop'
alias gstl='git stash list'
alias gf='git fetch --all --prune'
alias grh='git reset --hard'
alias grs='git restore'
alias grss='git restore --staged'
alias gcl='git clone'
alias gmain='git checkout main 2>/dev/null || git checkout master'

# ---------------------------------------------------------------------------
# Docker
# ---------------------------------------------------------------------------
alias d='docker'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias di='docker images'
alias drm='docker rm'                       # docker remove container
alias drmi='docker rmi'                     # docker remove image
alias drmf='docker rm -f'                   # force remove container
alias dprune='docker system prune -af'
alias dvprune='docker volume prune -f'
alias dex='docker exec -it'
alias dlog='docker logs -f'
alias dstop='docker stop'
alias dstart='docker start'
alias drestart='docker restart'
alias dbuild='docker build'
alias drun='docker run --rm -it'
alias dnet='docker network ls'

# Docker compose
alias dc='docker compose'
alias dcu='docker compose up -d'
alias dcd='docker compose down'
alias dcr='docker compose restart'
alias dcl='docker compose logs -f'
alias dcps='docker compose ps'
alias dcb='docker compose build'

# ---------------------------------------------------------------------------
# Kubernetes
# ---------------------------------------------------------------------------
alias k='kubectl'
alias kg='kubectl get'
alias kgp='kubectl get pods'
alias kgpa='kubectl get pods -A'
alias kgs='kubectl get svc'
alias kgd='kubectl get deploy'
alias kgn='kubectl get nodes'
alias kgns='kubectl get ns'
alias kd='kubectl describe'
alias kdp='kubectl describe pod'
alias kl='kubectl logs -f'
alias kex='kubectl exec -it'
alias kaf='kubectl apply -f'
alias kdf='kubectl delete -f'
alias kctx='kubectx 2>/dev/null || kubectl config get-contexts'
alias kns='kubens 2>/dev/null || kubectl config view --minify -o jsonpath="{..namespace}{\"\\n\"}"'

# ---------------------------------------------------------------------------
# Terraform / OpenTofu
# ---------------------------------------------------------------------------
alias tf='terraform'
alias tfi='terraform init'
alias tfp='terraform plan'
alias tfa='terraform apply'
alias tfaa='terraform apply -auto-approve'
alias tfd='terraform destroy'
alias tfv='terraform validate'
alias tff='terraform fmt -recursive'
alias tfs='terraform show'
alias tfo='terraform output'

# ---------------------------------------------------------------------------
# WSL-specific
# ---------------------------------------------------------------------------
alias open='wslview'                                  # open in Windows default app (if wslu installed)
alias cdwin='cd /mnt/c/Users/$USER'                   # jump to Windows user home
alias explorer='explorer.exe .'                       # open current dir in Windows Explorer
alias pbcopy='clip.exe'                               # mac-style clipboard
alias pbpaste='powershell.exe -command "Get-Clipboard" | tr -d "\r"'

# ---------------------------------------------------------------------------
# Misc dev
# ---------------------------------------------------------------------------
alias serve='python3 -m http.server 8000'
alias json='jq .'
alias weather='curl wttr.in'
