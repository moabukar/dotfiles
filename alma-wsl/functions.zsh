# alma-wsl/functions.zsh
# Handy shell functions. Sourced by alma-wsl/.zshrc.

# mkdir + cd
mkcd() {
  [[ $# -eq 1 ]] || { echo "usage: mkcd <dir>"; return 1; }
  mkdir -p "$1" && cd "$1"
}

# Extract pretty much anything
extract() {
  [[ -f "$1" ]] || { echo "extract: '$1' is not a file"; return 1; }
  case "$1" in
    *.tar.bz2|*.tbz2)  tar xjf  "$1" ;;
    *.tar.gz|*.tgz)    tar xzf  "$1" ;;
    *.tar.xz)          tar xJf  "$1" ;;
    *.tar)             tar xf   "$1" ;;
    *.bz2)             bunzip2  "$1" ;;
    *.gz)              gunzip   "$1" ;;
    *.zip)             unzip    "$1" ;;
    *.rar)             unrar x  "$1" ;;
    *.7z)              7z x     "$1" ;;
    *)  echo "extract: don't know how to handle '$1'"; return 1 ;;
  esac
}

# Find a process by name
psf() {
  [[ $# -ge 1 ]] || { echo "usage: psf <pattern>"; return 1; }
  ps aux | grep -v grep | grep -i "$1"
}

# Kill whatever is listening on a port
portkill() {
  [[ $# -eq 1 ]] || { echo "usage: portkill <port>"; return 1; }
  local pids
  pids="$(ss -tlnp 2>/dev/null | awk -v p=":$1" '$4 ~ p {print $0}' | grep -oP 'pid=\K[0-9]+' | sort -u)"
  if [[ -z "$pids" ]]; then
    echo "Nothing listening on :$1"
    return 1
  fi
  echo "Killing PID(s): $pids"
  kill -9 $pids
}

# Quick git: add all + commit + push
gacp() {
  [[ $# -ge 1 ]] || { echo "usage: gacp <commit message>"; return 1; }
  git add -A && git commit -m "$*" && git push
}

# Push current branch and set upstream
gpsup() {
  local branch
  branch="$(git symbolic-ref --short HEAD 2>/dev/null)" || { echo "not in a git repo"; return 1; }
  git push --set-upstream origin "$branch"
}

# Run a command in every immediate subdir that's a git repo
git-all() {
  [[ $# -ge 1 ]] || { echo "usage: git-all <git args...>"; return 1; }
  for d in */; do
    [[ -d "$d/.git" ]] || continue
    echo "==> $d"
    ( cd "$d" && git "$@" )
  done
}

# Show resolved DNS for a host
dnsf() {
  [[ $# -eq 1 ]] || { echo "usage: dnsf <host>"; return 1; }
  getent hosts "$1" || dig +short "$1"
}

# kubectl: tail logs from all containers of a pod
klogs() {
  [[ $# -ge 1 ]] || { echo "usage: klogs <pod> [namespace]"; return 1; }
  local ns_arg=""
  [[ -n "${2:-}" ]] && ns_arg="-n $2"
  kubectl logs -f --all-containers=true $ns_arg "$1"
}

# kubectl: exec into a pod's first container with bash, fall back to sh
ksh() {
  [[ $# -ge 1 ]] || { echo "usage: ksh <pod> [namespace]"; return 1; }
  local ns_arg=""
  [[ -n "${2:-}" ]] && ns_arg="-n $2"
  kubectl exec -it $ns_arg "$1" -- bash 2>/dev/null || kubectl exec -it $ns_arg "$1" -- sh
}

# Quick system info
sysinfo() {
  echo "user     : $(whoami)@$(hostname)"
  echo "os       : $(grep -E '^PRETTY_NAME' /etc/os-release | cut -d= -f2 | tr -d '\"')"
  echo "kernel   : $(uname -r)"
  echo "shell    : $SHELL"
  echo "uptime   : $(uptime -p)"
  if command -v free >/dev/null; then
    echo "memory   : $(free -h | awk '/^Mem:/ {print $3 " / " $2}')"
  fi
  echo "disk     : $(df -h / | awk 'NR==2 {print $3 " / " $2 " (" $5 ")"}')"
}
