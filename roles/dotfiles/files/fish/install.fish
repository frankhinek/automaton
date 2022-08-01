#!/usr/bin/env fish
for f in $DOTFILES/*/functions
	if not contains $f $fish_function_path
		set -Up fish_function_path $f
	end
end

for f in $DOTFILES/*/conf.d/*.fish
	ln -sf $f $__fish_config_dir/conf.d/(basename $f)
end

if test -f ~/.localrc.fish
	ln -sf ~/.localrc.fish $__fish_config_dir/conf.d/localrc.fish
end