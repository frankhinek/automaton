#!/usr/bin/env fish
abbr -a vim 'nvim'

# update plugins
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync' &>/dev/null