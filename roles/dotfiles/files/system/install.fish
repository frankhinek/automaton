#!/usr/bin/env fish
abbr -a less 'less -r'

if command -qs exa
    alias --save l='exa -lh --icons'
    alias --save ll='exa -l --icons'
    alias --save lt='exa -l --icons --tree --level=2'
else
    alias --save l='ls -lAh'
    alias --save ll='ls -l'
end

if command -qs fdfind
    ln -sf (which fdfind) ~/.bin/fd
end

if command -qa bat
    mkdir -p "$(bat --config-dir)"
    ln -sf $DOTFILES/system/bat.config $HOME/.config/bat/config
    alias --save cat=bat
    set -Ux MANPAGER "sh -c 'col -bx | bat -l man -p'"
end

if command -qs zoxide
    zoxide init fish >$__fish_config_dir/conf.d/zoxide.fish
end