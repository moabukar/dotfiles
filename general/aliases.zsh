# General

alias c='clear'
alias e='exit'
alias vi='vim'
alias h='history'
alias p='ps aux'
alias t='tail -f'
alias r='source ~/.zshrc'

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
