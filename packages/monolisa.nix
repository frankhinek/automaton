{ lib
, stdenvNoCC
, fetchFromGitHub
}:

stdenvNoCC.mkDerivation rec {
  pname = "monolisa-fonts";
  version = "v2.000";
  src = (fetchFromGitHub {
    owner = "frankhinek";
    repo = "fonts-licensed";
    rev = "main";
    sha256 = "11s01ysxg3777zvg85zb7snpfymr7zg8276vb7923nzvrvqq25a9";
  }).overrideAttrs (_: {
    GIT_CONFIG_COUNT = 1;
    GIT_CONFIG_KEY_0 = "url.https://github.com/.insteadOf";
    GIT_CONFIG_VALUE_0 = "ssh+git@github.com:";
  });

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