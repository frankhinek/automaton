{ config, pkgs, lib, ... }:

let
  monoLisaFonts = pkgs.stdenv.mkDerivation {
    name = "monolisa-fonts";
    src = pkgs.fetchFromGitHub {
      owner = "frankhinek";
      repo = "fonts-licensed";
      rev = "main";
      sha256 = ""; # You'll need to replace this with the actual hash
    };

    buildPhase = "true"; # No build needed

    installPhase = ''
      mkdir -p $out/share/fonts/truetype
      cp "$src/MonoLisa-Plus/v2.000/ttf-nerd-font/"*.ttf $out/share/fonts/truetype/
    '';

    # Adding meta information
    meta = with lib; {
      description = "MonoLisa Nerd Font collection";
      license = licenses.unfree;
      platforms = platforms.all;
    };
  };
in
{
  fonts.fontDir.enable = true; # Enable font directory
  fonts.packages = [ monoLisaFonts ];

  # If you're using home-manager, use this instead:
  # home.packages = [ monoLisaFonts ];
}