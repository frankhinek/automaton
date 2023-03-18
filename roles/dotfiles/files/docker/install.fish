#!/usr/bin/env fish
curl -sL https://raw.githubusercontent.com/docker/cli/master/contrib/completion/fish/docker.fish -o $__fish_config_dir/completions/docker.fish

alias --save d=docker
alias --save dc=docker-compose