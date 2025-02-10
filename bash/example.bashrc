
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
    local cur
    _init_completion || return

    cur="${COMP_WORDS[COMP_CWORD]}"

    # Fetch completions via SSH
    local IFS=$'\n'
    local -a completions
    completions=($(ssh "$RAH" compgen -A file -- "$cur"))

    # If there's only one completion, append it directly
    if [[ ${#completions[@]} -eq 1 ]]; then
        COMPREPLY=( "${completions[0]}" )
        return 0
    fi

    # Otherwise, provide completions as filenames only
    COMPREPLY=()
    for path in "${completions[@]}"; do
        COMPREPLY+=( "${path##*/}" )
    done
}

complete -F _s_completion s

#</ ADDITIONS >#
