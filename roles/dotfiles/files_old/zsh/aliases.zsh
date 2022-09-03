#!/usr/bin/env zsh

if [ "$(uname)" = "Linux" ]; then
    #eval `dircolors ~/.dir_colors`
    export LS_OPTIONS='--color=auto'
else
    export LS_OPTIONS='-G'
fi

# Set aliases for list directory contents command
alias ls='ls $LS_OPTIONS -hF'
alias ll='ls $LS_OPTIONS -lAhF'
