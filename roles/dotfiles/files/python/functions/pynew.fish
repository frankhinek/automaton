function pynew -d "create a new Python project"
  poetry new $argv[1]
    and cd (basename $argv[1] .git)
  git init -b main
  gi python
  poetry shell
  poetry add -G dev pytest mkdocs-material black
  mkdocs new .
end