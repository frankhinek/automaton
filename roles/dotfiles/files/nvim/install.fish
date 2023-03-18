#!/usr/bin/env fish
alias --save vim='nvim'

# update plugins
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync' &>/dev/null