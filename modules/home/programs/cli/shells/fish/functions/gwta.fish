function gwta -d "add a new worktree and change directory"
    set -l repo $argv[1]
    set -l name $argv[2]
    set -l base $argv[3]

    if test -z "$repo" -o -z "$name"
        echo "Usage: gwta <repo> <name> [base]"
        return 1
    end

    # Bare repo is at $HOME/Developer/{repo}.git
    set -l bare_repo "$HOME/Developer/$repo.git"

    if test -z "$base"
        # Ensure remote refs are fetched for bare repos
        git -C "$bare_repo" fetch origin '+refs/heads/*:refs/remotes/origin/*' 2>/dev/null

        pushd "$bare_repo" >/dev/null
        set -l default_branch (git-main-branch)
        popd >/dev/null
        if test $status -ne 0
            echo "Failed to determine default branch."
            return 1
        end
        set base "origin/$default_branch"
    end

    # Worktrees go in $HOME/Developer/_wt/{repo}/{branch}
    mkdir -p "$HOME/Developer/_wt/$repo"

    git -C "$bare_repo" worktree add --guess-remote -b "$name" \
        "$HOME/Developer/_wt/$repo/$name" "$base"
    or git -C "$bare_repo" worktree add --guess-remote \
        "$HOME/Developer/_wt/$repo/$name" "$name"

    cd "$HOME/Developer/_wt/$repo/$name"
end
