#!/usr/bin/env fish
if test (uname) != Darwin
    exit
end

set homebrew_bin_path (dirname (which brew))

fish_add_path -a /usr/local/sbin $homebrew_bin_path || true
