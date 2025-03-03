
#< ADDITIONS >#

# RETURN IF NONINTERACTIVE
[[ $- != *i* ]] && return

# SOURCE GLOBAL BASHRC
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# LOAD LOCAL COMMANDS
export PATH="$HOME/.local/bin:$PATH"

# PERSONAL
echo -ne "\e[2 q"
export PS1="[\u@\h\[\033[01;36m\] \w\[\033[00m\]]\$ " #\$(__git_ps1)
export HISTCONTROL=erasedups

# NEW COMMANDS
clear_screen() { printf "\033[2J\033[3J\033[H"; }
how() {
    [ $1 == "help" ] && { help help | { less || more || cat; }; } && return
    { $1 --help || $1 -h || { man $1 | grep -iA 1 "^ *\-[a-z]"; }; } | { less || more || cat; }
}

bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind -x '"\el": clear_screen'

#</ ADDITIONS >#
