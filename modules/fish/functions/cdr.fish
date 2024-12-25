function cdr -d "cd back to the root directory of the current repository"
    cd (git rev-parse --show-toplevel)
end