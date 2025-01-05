# function dev --description 'Wrapper for nix develop with shell shortcuts'
# #    cd ~/.automaton
#    if test (count $argv) -eq 0
#        nix develop $AUTOMATON_HOME/.# -c $SHELL
#    else
#        nix develop $AUTOMATON_HOME/.#$argv[1] -c $SHELL
#    end
# #    cd -
# end
function dev --description 'Wrapper for nix develop with shell shortcuts'
    set -l original_dir (pwd)
    cd $AUTOMATON_HOME

    if test (count $argv) -eq 0
        nix develop .# -c $SHELL
    else
        nix develop .#$argv[1] -c $SHELL
    end

    if test -d $original_dir
        cd $original_dir
    else
        cd -
    end
end
