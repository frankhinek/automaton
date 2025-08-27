function gwtd -d "delete and prune a git worktree"
    set -l repo $argv[1]
    set -l name $argv[2]

    if test -z "$repo" -o -z "$name"
        echo "Usage: gwtd <repo> <name>"
        return 1
    end

    # Bare repo is at $HOME/Developer/{repo}.git
    set -l bare_repo "$HOME/Developer/$repo.git"
    set -l worktree_path "$HOME/Developer/_wt/$repo/$name"

    # Remove the worktree
    git -C "$bare_repo" worktree remove "$worktree_path"

    # Prune worktree references
    git -C "$bare_repo" worktree prune
end
