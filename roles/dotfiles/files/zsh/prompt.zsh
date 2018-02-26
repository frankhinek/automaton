#!/usr/bin/env zsh
#PURE_CMD_MAX_EXEC_TIME=1

# Prompt
SPACESHIP_PROMPT_ORDER=(
  # time        # Time stampts section (Disabled)
  user          # Username section
  dir           # Current directory section
  host          # Hostname section
  git           # Git section (git_branch + git_status)
  # hg          # Mercurial section (hg_branch  + hg_status) (Disabled)
  # package     # Package version (Disabled)
  node          # Node.js section
  ruby          # Ruby section
  # elixir      # Elixir section (Disabled)
  # xcode       # Xcode section (Disabled)
  # swift       # Swift section (Disabled)
  golang        # Go section
  # php         # PHP section (Disabled)
  # rust        # Rust section (Disabled)
  # haskell     # Haskell Stack section (Disabled)
  # julia       # Julia section (Disabled)
  docker        # Docker section
  aws           # Amazon Web Services section
  venv          # virtualenv section
  conda         # conda virtualenv section
  pyenv         # Pyenv section
  # dotnet      # .NET section (Disabled)
  # ember       # Ember.js section (Disabled)
  kubecontext   # Kubectl context section
  exec_time     # Execution time
  line_sep      # Line break
  # battery     # Battery level and status (Disabled)
  # vi_mode     # Vi-mode indicator (Disabled)
  jobs          # Background jobs indicator
  # exit_code   # Exit code section
  char          # Prompt character
)

# Char
SPACESHIP_CHAR_SYMBOL=❯        # Prompt character to be shown before any command
SPACESHIP_CHAR_SUFFIX=" "      # Suffix after prompt character

# Conda
SPACESHIP_CONDA_COLOR=cyan     # Color of conda virtualenv environment section

# Dir
SPACESHIP_DIR_COLOR=blue       # Color of directory section

# Venv
SPACESHIP_VENV_COLOR=cyan      # Color of virtualenv environment section
