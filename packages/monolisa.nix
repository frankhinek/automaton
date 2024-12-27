{
  stdenvNoCC,
  lib,
}:
stdenvNoCC.mkDerivation {
  pname = "monolisa-nerdfonts";
  version = "v2.000";
  src = ./.;

  buildPhase = "true"; # No build needed

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp "$src/fonts/MonoLisa-Plus/$version/ttf-nerd-font/"*.ttf $out/share/fonts/truetype/
  '';

  # Adding meta information
  meta = with lib; {
    description = "MonoLisa Nerd Fonts";
    homepage = "https://www.monolisa.dev/";
    license = licenses.unfree;
    platforms = platforms.all;
  };
}