function gwtl
    set -l repo $argv[1]
    if test -n "$repo"
        git -C "$HOME/Developer/$repo" worktree list --porcelain | awk '/worktree /{print $2}'
    else
        git worktree list --porcelain | awk '/worktree /{print $2}'
    end
end
