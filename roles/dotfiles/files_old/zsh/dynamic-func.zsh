#!/usr/bin/env zsh

# Idea and code source:
#   https://github.com/jkramer/home/blob/master/.zsh/func/magic

_MAGIC_FILE=".zshrc"
_LAST_DIRECTORY=""

# Magically source files when changing directories. When changing to another
# directory, search the directory and its parents for a file called ".zshrc"
# and source it, if found. Useful to set stuff for projects
# automatically, like exporting PERL5LIB, generating ctags files, setting up
# project-specific aliases etc.
function src_magic; {
	DIRECTORY="$PWD"
	FOUND=""

	while true; do
		[[ $PWD = '/' || $PWD == $HOME ]] && break

		if [ -f "./$_MAGIC_FILE" ]; then
			FOUND="$PWD"
			break
		fi

		builtin cd -q ..
	done

	if [[ -z $FOUND ]]; then
		if [[ ! -z $_LAST_DIRECTORY ]]; then
			if [[ ! -z $functions[unmagic] ]]; then
				unmagic
				functions[unmagic]=""
			fi
			_LAST_DIRECTORY=""
		fi
	else
		if [[ $FOUND != $_LAST_DIRECTORY ]]; then
			source "$FOUND/$_MAGIC_FILE"
			_LAST_DIRECTORY="$PWD"
		fi
	fi

	builtin cd -q "$DIRECTORY"
}

# Enable the dynamic_git_user function hook
chpwd_functions=(${chpwd_functions[@]} "src_magic")
