#!/usr/bin/env zsh

# Make completion:
# - Case-insensitive.
# - Accept abbreviations after . or _ or - (ie. f.b -> foo.bar).
# - Substring complete (ie. bar -> foobar).
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# pasting with tabs doesn't perform completion
zstyle ':completion:*' insert-tab pending

# select completions from a menu with arrow keys if 2 candidates or more
zstyle ':completion:*' menu select=2

# colors
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# list of completers to use
zstyle ':completion:*::::' completer _expand _complete _ignored _approximate

# Messages/warnings format
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format $'%{\e[01;34m%}---- %d%{\e[00;36m%}'
zstyle ':completion:*:messages' format $'%{\e[01;04;31m%}---- %d%{\e[m%}'
zstyle ':completion:*:warnings' format $'%{\e[01;04;31m%}---- No matches for: %d%{\e[m%}'
zstyle ':completion:*:corrections' format $'%{\e[0;31m%}%d (errors: %e)%{\e[m%}'

# make completions appear below the description of which listing they come from
zstyle ':completion:*' group-name ''
zstyle ':completion:*:default' select-prompt %SScrolling active: current selection at %p%s

# complete man pages
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:manuals.(^1*)' insert-sections true

# Ignore completion functions for commands you don't have:
zstyle ':completion:*:functions' ignored-patterns '_*'

# A newly added command will may not be found or will cause false
# correction attempts, if you got auto-correction set. By setting the
# following style, we force accept-line() to rehash, if it cannot
# find the first word on the command line in the $command[] hash.
zstyle ':acceptline:*' rehash true