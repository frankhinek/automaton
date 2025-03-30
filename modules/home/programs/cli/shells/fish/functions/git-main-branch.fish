# Function to determine and echo the primary branch name (main or master)
function git-main-branch --description "Outputs the primary branch name (main or master)"
    # 1. Check remote HEAD symbolic ref
    set -l default_branch (git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@')
    if test "$default_branch" = main -o "$default_branch" = master
        echo $default_branch
        return 0
    end

    # 2. Check if origin/main exists (remote tracking ref)
    if git rev-parse --verify --quiet origin/main >/dev/null 2>&1
        echo main
        return 0
    end

    # 3. Check if origin/master exists (remote tracking ref)
    if git rev-parse --verify --quiet origin/master >/dev/null 2>&1
        echo master
        return 0
    end

    # 4. Check if local main exists
    if git rev-parse --verify --quiet main >/dev/null 2>&1
        echo main
        return 0
    end

    # 5. Check if local master exists
    if git rev-parse --verify --quiet master >/dev/null 2>&1
        echo master
        return 0
    end

    echo "Error: Could not determine the primary branch (main/master) for this repository." >&2
    return 1 # Indicate failure
end
