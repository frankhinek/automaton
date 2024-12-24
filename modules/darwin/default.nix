{ ... }:
{
  home.homeDirectory = "/Users/frank";

  programs.fish.shellInit = ''
    fish_add_path -a /opt/homebrew/bin/
  '';

  # never index the developer folder in spotlight.
  home.file."Developer/.metadata_never_index".text = "";
}