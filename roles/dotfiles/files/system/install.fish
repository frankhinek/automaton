#!/usr/bin/env fish
abbr -a less 'less -r'

if command -qs exa
	abbr -a l 'exa -lh --icons'
	abbr -a ll 'exa -l --icons'
	abbr -a lt 'exa -l --icons --tree --level=2'
else
	abbr -a l 'ls -lAh'
	abbr -a ll 'ls -l'
end

if command -qs fdfind
	alias --save fd=fdfind
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