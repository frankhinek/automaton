#!/usr/bin/env fish

# Don't ask ssh password all the time
switch (uname)
    case Darwin
        git config --global credential.helper osxkeychain
    case '*'
        git config --global credential.helper cache
end

# better diffs
if command -qs delta
    git config --global core.pager delta
    git config --global interactive.diffFilter 'delta --color-only'
    git config --global delta.line-numbers true
    git config --global delta.decorations true
end

alias --save g='git'
alias --save gsu='git submodule update --init --recursive'
alias --save gl='git pull --prune'
alias --save glg="git log --graph --decorate --oneline --abbrev-commit"
alias --save glga="glg --all"
alias --save gp='git push origin HEAD'
alias --save gpa='git push origin --all'
alias --save gd='git diff'
alias --save gc='git commit -s'
alias --save gca='git commit -sa'
alias --save gco='git checkout'
alias --save gb='git branch -v'
alias --save gbl='git branch --list'
alias --save gbr='git branch --remotes'
alias --save ga='git add'
alias --save gaa='git add -A'
alias --save gcm='git commit -sm'
alias --save gcam='git commit -sam'
alias --save gs='git status -sb'
alias --save gw='git switch'
alias --save gwc='git switch -c'