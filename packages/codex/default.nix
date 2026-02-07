{ lib, stdenv, fetchurl, nodejs_22, makeWrapper, }:

stdenv.mkDerivation rec {
  pname = "codex";
  version = "0.98.0";

  src = fetchurl {
    url = "https://registry.npmjs.org/@openai/codex/-/codex-${version}.tgz";
    hash = "sha256-oo/RkmlckH+qBgFTxKrkqZ6KCHhy6TTdCFVkjWW0sqc=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ nodejs_22 ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    # Create the installation directory
    mkdir -p $out/lib/codex

    # Extract and install the package
    tar -xf $src --strip-components=1 -C $out/lib/codex

    # Create bin directory
    mkdir -p $out/bin

    # Create wrapper for the codex command
    makeWrapper ${nodejs_22}/bin/node $out/bin/codex \
      --add-flags "$out/lib/codex/bin/codex.js" \
      --set NODE_PATH "$out/lib/codex:$out/lib/codex/node_modules" \
      --set DISABLE_AUTOUPDATER 1 \
      --set AUTHORIZED 1 \
      --unset DEV

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Lightweight coding agent that runs in your terminal";
    homepage = "https://github.com/openai/codex";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
    mainProgram = "codex";
  };
}
