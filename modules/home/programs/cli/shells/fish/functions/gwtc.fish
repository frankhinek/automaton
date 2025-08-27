function gwtc -d "clone bare git repository for worktree usage"
    if test -z "$argv[1]"
        echo "Usage: gwtc <repository-url>"
        return 1
    end

    # Extract repo name from URL (handles both .git suffix and without)
    set -l repo_name (basename $argv[1] .git)
    set -l bare_repo_path "$HOME/Developer/$repo_name.git"

    # Check if destination already exists
    if test -e "$bare_repo_path"
        echo "Error: Destination already exists: $bare_repo_path"
        return 1
    end

    # Clone as bare repository and fetch refs
    git clone --bare $argv[1] "$bare_repo_path"
    and git -C "$bare_repo_path" fetch origin '+refs/heads/*:refs/remotes/origin/*'
end
