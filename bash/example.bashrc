
#< ADDITIONS >#

# source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# load local bin in path if not yet in path
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# thick cursor
echo -ne "\e[2 q"

# alter user@host to be a little more readable
export PS1="[\u@\h\[\033[01;36m\] \w\$(__git_ps1)\[\033[00m\]]\$ "
# export PS1="[\u@\h\[\033[01;36m\] \w\[\033[00m\]]\$ "  # if __git_ps1 not recognized

# history preferences, erase duplicates
export HISTSIZE=200
export HISTFILESIZE=600
export HISTCONTROL=erasedups
export HISTIGNORE="cd*:ls*"

# bindings
bind '"\e[A": history-search-backward'  # up-arrow: older command-specific history
bind '"\e[B": history-search-forward'  # down-arrow: newer command-specific history

# helper funcs
code() {  # open with preferred code editor
    command "${VISUAL:-${EDITOR:-$(command -v vim || command -v vi || command -v nano)}}" "$@"
}

how() {  # quick help from man, default focus on flags/options
    [[ -z "$1" || "$1" == "-h" || "$1" == "--help" ]] && { echo -e "Usage  : how [command] [pattern]\nSimple : how grep\nFull   : how grep '-r'"; return; }
    man "$1" | col -b | grep -i -- "${2:-[^a-z]-[a-z]}" && [ $# -gt 2 ] && echo -e "\n>> INFO >> how accepts 1 or 2 args <<"
}

#</ ADDITIONS >#
