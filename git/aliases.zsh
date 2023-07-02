# Use `hub` as our git wrapper:
#   http://defunkt.github.com/hub/
hub_path=$(which hub)
if (( $+commands[hub] ))
then
  alias git=$hub_path
fi

# My Git aliases
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
alias gd='git diff'
alias gds='git diff --staged'
alias gr='git remote'
alias gra='git remote add'
alias grr='git remote remove'
alias gf='git fetch'
alias gfp='git fetch --prune'
alias gcl='git clone'
alias gmv='git mv'
alias grb='git rebase'
alias grbc='git rebase --continue'
alias grbs='git rebase --skip'
alias grab='git rebase --abort'
alias gt='git tag'
alias gta='git tag -a'
alias gtd='git tag -d'
alias gtv='git verify-tag'
alias gch='git cherry-pick'
alias gcha='git cherry-pick --abort'
alias gchc='git cherry-pick --continue'
alias gsh='git stash'
alias gsha='git stash apply'
alias gsph='git stash pop'
alias gsl='git stash list'