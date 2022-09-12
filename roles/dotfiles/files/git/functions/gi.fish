function gi -d "generate .gitignore file for current repo"
	curl -sL https://www.toptal.com/developers/gitignore/api/$argv > .gitignore
end