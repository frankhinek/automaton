{ ... }:
{
  home.homeDirectory = "/Users/frank";

  # ensures ~/Pictures/screenshots directory exists.
  home.activation.screenshots = ''
    mkdir -p ~/Pictures/screenshots
  '';

  programs.fish.shellInit = ''
    fish_add_path -a /opt/homebrew/bin/
  '';

  # never index the ~/Developer directory in spotlight.
  home.file."Developer/.metadata_never_index".text = "";
}