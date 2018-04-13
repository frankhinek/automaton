#!/usr/bin/env zsh

kubectl() {
	source <(command kubectl completion zsh)
	command kubectl "$@"
}

alias k='kubectl'