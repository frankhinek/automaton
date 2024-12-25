function gcl -d "clone git repository and change directory"
	git clone $argv[1]
    	and cd (basename $argv[1] .git)
end