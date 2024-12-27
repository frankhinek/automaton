{ config, pkgs, ... }:

let
  # If you have multiple fonts, you can make a list of fetchgit calls.
  monolisa = pkgs.fetchgit {
    url = "https://github.com/frankhinek/fonts-licensed.git";
    rev = "main";
    sha256 = "11s01ysxg3777zvg85zb7snpfymr7zg8276vb7923nzvrvqq25a9";
  };
in {
  # Enable Home Manager’s built-in font support
  xdg.fontDir.enable = true;

  fonts.fonts = [
    {
      name = "MonoLisa-nerd";
      # Points Home Manager to the directory containing .ttf files
      path = "${monolisa}/MonoLisa-Plus/v2.000/ttf-nerd-font";
    }
  ];
}
