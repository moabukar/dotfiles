# ~/.zshrc -> alma-wsl/.zshrc
# AlmaLinux on WSL — lean zsh config focused on daily dev work.

# Powerlevel10k instant prompt — keep near the top.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ---------------------------------------------------------------------------
# Locate this dotfiles directory (handles the symlink ~/.zshrc -> alma-wsl/.zshrc)
# ---------------------------------------------------------------------------
ZSHRC_REAL="${${(%):-%N}:A}"
ALMA_WSL_DIR="${ZSHRC_REAL:h}"
DOTFILES_DIR="${ALMA_WSL_DIR:h}"

# ---------------------------------------------------------------------------
# Environment
# ---------------------------------------------------------------------------
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export EDITOR=vim
export VISUAL=vim
export PAGER=less
export LESS='-R -F -X'

export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=50000
export SAVEHIST=50000

export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1

# PATH — user-local first
typeset -U path PATH
path=(
  "$HOME/.local/bin"
  "$HOME/bin"
  "$HOME/go/bin"
  "$HOME/.npm-global/bin"
  $path
)
export PATH

# ---------------------------------------------------------------------------
# Oh My Zsh
# ---------------------------------------------------------------------------
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  git
  docker
  docker-compose
  kubectl
  terraform
  helm
  colored-man-pages
  command-not-found
  fzf
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-completions
)

ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="yyyy-mm-dd"

if [[ -f "$ZSH/oh-my-zsh.sh" ]]; then
  source "$ZSH/oh-my-zsh.sh"
fi

# ---------------------------------------------------------------------------
# History behaviour
# ---------------------------------------------------------------------------
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY

# ---------------------------------------------------------------------------
# Aliases + functions
# ---------------------------------------------------------------------------
[[ -f "$ALMA_WSL_DIR/aliases.zsh"   ]] && source "$ALMA_WSL_DIR/aliases.zsh"
[[ -f "$ALMA_WSL_DIR/functions.zsh" ]] && source "$ALMA_WSL_DIR/functions.zsh"

# Local-only overrides (not committed)
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

# ---------------------------------------------------------------------------
# Tool init (only if the tool is installed)
# ---------------------------------------------------------------------------
command -v fzf       >/dev/null && [[ -f /usr/share/fzf/shell/key-bindings.zsh ]] && source /usr/share/fzf/shell/key-bindings.zsh
command -v kubectl   >/dev/null && source <(kubectl completion zsh) && compdef k=kubectl
command -v helm      >/dev/null && source <(helm completion zsh)
command -v terraform >/dev/null && complete -o nospace -C "$(command -v terraform)" terraform

# nvm (if present)
if [[ -d "$HOME/.nvm" ]]; then
  export NVM_DIR="$HOME/.nvm"
  [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
fi

# ---------------------------------------------------------------------------
# Powerlevel10k theme config
# ---------------------------------------------------------------------------
[[ -f "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
