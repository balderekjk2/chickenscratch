
#< ADDITIONS >#

# return if non-interactive shell
[[ $- != *i* ]] && return

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

# clear screen and scrollback
clear_screen() { printf "\033[2J\033[3J\033[H"; }
bind -x '"\el": clear_screen'

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

# Running `wsl ~` from command prompt grants access to windows utilities
wcopy() {
    cat "$1" | clip.exe
}

alias wpaste='powershell.exe Get-Clipboard'

# nnn, preferred file explorer
alias nnn='nnn -e' # always open files with EDITOR
# export EDITOR=micro # or vim, nano, etc.

# ssh from within shell to harness benefits of universal clipboard if X11 is not possible
s() {
    if [[ "$1" == "-c" ]]; then
        shift
        ssh "$RAH" "$@" | tee >(clip.exe)
    else
        ssh "$RAH" "$@"
    fi
}

_s_completion() {
    local cur prev words cword
    _init_completion || return

    cur="${words[cword]}"
    prev="${words[cword-1]}"

    # Handle the "-c" flag case
    if [[ ${words[1]} == "-c" ]]; then
        if [[ $cword -eq 2 ]]; then
            COMPREPLY=( $(compgen -A command -- "$cur") )
            return 0
        fi
    fi

    # If first argument is a flag, suggest valid options
    if [[ $cword -eq 1 && $cur == -* ]]; then
        COMPREPLY=( $(compgen -W "-c" -- "$cur") )
        return 0
    fi

    # Use SSH to fetch completions and extract only filenames (no paths)
    if [[ $cword -gt 1 ]]; then
        # Fetch completions via SSH and extract just the filenames using `awk`
        COMPREPLY=( $(
            ssh "$RAH" compgen -A file -- "$cur" | awk -F/ '{print $NF}'
        ) )
        return 0
    fi
}

complete -F _s_completion s

#</ ADDITIONS >#
