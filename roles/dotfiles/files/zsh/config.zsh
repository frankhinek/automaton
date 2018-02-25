#!/usr/bin/env zsh

export LSCOLORS='exfxcxdxbxegedabagacad'
export CLICOLOR=true

# Load c, h, etc. functions
fpath=($DOTFILES/zsh/functions $fpath)
autoload -U "$DOTFILES"/zsh/functions/*(:t)

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search

##
# Prompt
##
setopt PROMPT_SUBST     # allow funky stuff in prompt

##
# Completion
##
setopt ALWAYS_TO_END            # when completing from the middle of a word, move the cursor to the end of the word
setopt COMPLETE_IN_WORD         # allow completion from within a word/phrase
setopt CORRECT                  # spelling correction for commands
setopt LIST_AMBIGUOUS           # complete as much of a completion until it gets ambiguous.

##
# History
##
HISTFILE=~/.zsh_history         # where to store zsh history
HISTSIZE=10000                  # big history
SAVEHIST=$HISTSIZE              # big history
setopt APPEND_HISTORY           # append
setopt BANG_HIST                # !keyword
setopt EXTENDED_HISTORY         # add timestamps to history
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_ALL_DUPS     # no duplicates
setopt HIST_IGNORE_DUPS         # no duplicates
unsetopt HIST_IGNORE_SPACE      # don't ignore space prefixed commands
setopt HIST_REDUCE_BLANKS       # trim blanks
setopt HIST_VERIFY              # show before executing history commands
setopt INC_APPEND_HISTORY       # add commands as they are typed, don't wait until shell exit
setopt SHARE_HISTORY            # share history between sessions

##
# Various
##
setopt AUTO_CD                  # if command is a path, cd into it
unsetopt BEEP                   # no bell on error
unsetopt BG_NICE                # no lower priority for background jobs
unsetopt HIST_BEEP              # no bell on error in history
unsetopt HUP                    # no hup signal at shell exit
unsetopt LIST_BEEP              # no bell on ambiguous completion
setopt LOCAL_OPTIONS            # allow functions to have local options
setopt LOCAL_TRAPS              # allow functions to have local traps
setopt PRINT_EXIT_VALUE         # print return value if non-zero
unsetopt RM_STAR_SILENT         # ask for confirmation for `rm *' or `rm path/*'

zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

##
# Key bindings
##
# Lookup in /etc/termcap or /etc/terminfo else, you can get the right keycode
# by typing ^v and then type the key or key combination you want to use.
# "man zshzle" for the list of available actions
bindkey '^P'     up-line-or-history            # [Ctrl-P] - Up a line of history
bindkey '^N'     down-line-or-history          # [Ctrl-N] - Down a line of history
bindkey '^[[A'   history-substring-search-up   # start typing + [Up-Arrow] - fuzzy find history forward
bindkey '^[[B'   history-substring-search-down # start typing + [Down-Arrow] - fuzzy find history backward
bindkey '^[^[[D' backward-word                 # [Alt-RightArrow] - move forward one word
bindkey '^[^[[C' forward-word                  # [Alt-RightArrow] - move forward one word
bindkey '^A'     beginning-of-line             # [Ctrl-A] - Go to beginning of line
bindkey '^E'     end-of-line                   # [Ctrl-E] - Go to end of line
bindkey '^[[3~'  delete-char                   # [fn-Delete] - delete forward
bindkey '^?'     backward-delete-char          # [Backspace] - delete backward

# [Home] - Go to beginning of line
if [[ ! -z "$terminfo[khome]" ]]; then
  bindkey "$terminfo[khome]" beginning-of-line
fi

# [End] - Go to end of line
if [[ ! -z "$terminfo[kend]" ]]; then
  bindkey "$terminfo[kend]"  end-of-line
fi

# # [Shift-Tab] - move through the completion menu backwards
if [[ ! -z "$terminfo[kcbt]" ]]; then
  bindkey "$terminfo[kcbt]" reverse-menu-complete
fi
