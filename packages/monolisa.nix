{ builtins, lib, stdenvNoCC }:

stdenvNoCC.mkDerivation rec {
  pname = "monolisa-fonts";
  version = "v2.000";
  src = builtins.fetchGit {
    # Use SSH URL for cloning
    url = "git@github.com:frankhinek/fonts-licensed.git";
    ref = "80624e90e6eaee82ba1ad68256273cef42d39f16";
  };

  buildPhase = "true"; # No build needed

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp "$src/MonoLisa-Plus/$version/ttf-nerd-font/"*.ttf $out/share/fonts/truetype/
  '';

  # Adding meta information
  meta = with lib; {
    description = "MonoLisa Nerd Fonts";
    homepage = "https://www.monolisa.dev/";
    license = licenses.unfree;
    platforms = platforms.all;
  };
}