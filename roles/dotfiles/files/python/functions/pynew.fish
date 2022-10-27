function pynew -d "create a new Python project"
  poetry new $argv[1]
    and cd (basename $argv[1] .git)
  wait
  git init -b main
  wait
  gi python
  wait
  poetry shell
  wait
  poetry add -G dev pytest mkdocs-material black
  wait
  mkdocs new .
  wait
end