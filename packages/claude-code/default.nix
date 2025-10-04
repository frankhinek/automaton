{
  lib,
  stdenv,
  fetchurl,
  nodejs_20,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "claude-code";
  version = "2.0.5";

  src = fetchurl {
    url = "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-${version}.tgz";
    hash = "sha256-vT+Csqi3vtAbQam6p2qzefBycFDkUO+k5EdHHcCPT2k=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ nodejs_20 ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    # Create the installation directory
    mkdir -p $out/lib/claude-code

    # Extract and install the package
    tar -xf $src --strip-components=1 -C $out/lib/claude-code

    # Create bin directory
    mkdir -p $out/bin

    # Create wrapper for the claude command
    makeWrapper ${nodejs_20}/bin/node $out/bin/claude \
      --add-flags "$out/lib/claude-code/cli.js" \
      --set NODE_PATH "$out/lib/claude-code:$out/lib/claude-code/node_modules" \
      --set DISABLE_AUTOUPDATER 1 \
      --set AUTHORIZED 1 \
      --unset DEV

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Agentic coding tool that lives in your terminal, understands your codebase, and helps you code faster";
    homepage = "https://github.com/anthropics/claude-code";
    downloadPage = "https://www.npmjs.com/package/@anthropic-ai/claude-code";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.all;
    mainProgram = "claude";
  };
}
