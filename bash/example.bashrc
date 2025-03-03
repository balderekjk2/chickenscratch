
#< ADDITIONS >#

# RETURN IF NONINTERACTIVE
[[ $- != *i* ]] && return

# SOURCE GLOBAL BASHRC
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# LOAD LOCAL COMMANDS
export PATH="$HOME/.local/bin:$PATH"

# KRB5 CONFIG
export KRB5_CONFIG=/usr/local/krb5/etc/krb5.conf
export PATH="/usr/local/krb5/bin:/usr/local/ossh/bin:$PATH"
export PATH=$PATH:/usr/sbin:/usr/sbin/iptables:/usr/sbin/ip6tables

# PYENV CONFIG
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init -)"
fi

# NVM CONFIG
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# PERSONAL
echo -ne "\e[2 q"
export PS1="[\u@\h\[\033[01;36m\] \w\[\033[00m\]]\$ " #\$(__git_ps1)
export HISTCONTROL=erasedups

one="${1:-help}" # GLOBAL FIRST ARG

clear_screen() { printf "\033[2J\033[3J\033[H"; }
how() {
    [ $one == "help" ] && { help help | { less || more || cat; }; } && return
    { $one --help || $one -h || { man $one | grep -iA 1 "^ *\-[a-z]"; }; } | { less || more || cat; }
}

bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind -x '"\el": clear_screen'

alias cato="bat -p"
alias nnna="nnn -eH"
alias lynxo="lynx -use_mouse"
export PATH=$PATH:/var/lib/snapd/snap/bin

#</ ADDITIONS >#
