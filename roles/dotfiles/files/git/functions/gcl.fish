function gcl -d "clone git repository and change directory"
	git clone $argv[1]
    	and cd $argv[1]
end