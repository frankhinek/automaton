function gwt
    set -l gd (git rev-parse --git-dir 2>/dev/null)
    if test $status -ne 0
        return 1
    end
    if string match -q '*/worktrees/*' $gd
        basename $gd
    else
        git rev-parse --abbrev-ref HEAD 2>/dev/null
    end
end
