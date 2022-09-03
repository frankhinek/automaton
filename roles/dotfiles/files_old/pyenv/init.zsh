#!/usr/bin/env zsh

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# Disable modifying the shell prompt when a virtualenv is activated
# Spaceship prompt already contains the informaiton
export VIRTUAL_ENV_DISABLE_PROMPT=1
