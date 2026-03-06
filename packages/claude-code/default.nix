{ lib, stdenvNoCC, fetchurl }:

let
  version = "2.1.69";
  releaseBaseUrl =
    "https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases";

  arch = if stdenvNoCC.hostPlatform.isx86_64 then
    "x64"
  else if stdenvNoCC.hostPlatform.isAarch64 then
    "arm64"
  else
    throw
    "claude-code: unsupported architecture ${stdenvNoCC.hostPlatform.system}";

  platform = if stdenvNoCC.hostPlatform.isDarwin then
    "darwin-${arch}"
  else if stdenvNoCC.hostPlatform.isLinux then
    if stdenvNoCC.hostPlatform.isMusl then
      "linux-${arch}-musl"
    else
      "linux-${arch}"
  else
    throw "claude-code: unsupported platform ${stdenvNoCC.hostPlatform.system}";

  sourceHashes = {
    "darwin-arm64" = "sha256-qG4U9EsWfB6Nv3ZPdnVbkuz1LAl9cyo0Yf5ltftgvgU=";
    "darwin-x64" = "sha256-5Zh7TdUCplQr+Gw8C80dUzt3Rhb8fUlWbOCyBA5sE3Q=";
    "linux-arm64" = "sha256-7Me78QUT/xIjJ4ZuuXISlFtzr9f4HjBwA3XN8Q9QsqM=";
    "linux-x64" = "sha256-s729Wjy/jKr+NTAiFw33f++oCwAAMHTU0n59qMWeYpo=";
    "linux-arm64-musl" = "sha256-DSxxc6aMWptFHwkJON5uzl8Wkj0ovNlx2xYmSkN7f64=";
    "linux-x64-musl" = "sha256-fk1Rthm+0D9YUORNzTm2Wu5OdCVBH/rHIje8HBRyIYE=";
  };
in stdenvNoCC.mkDerivation {
  pname = "claude-code";
  inherit version;

  src = fetchurl {
    url = "${releaseBaseUrl}/${version}/${platform}/claude";
    hash = sourceHashes.${platform};
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 "$src" "$out/bin/claude"
    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description =
      "Agentic coding tool that lives in your terminal, understands your codebase, and helps you code faster";
    homepage = "https://docs.anthropic.com/en/docs/claude-code";
    downloadPage =
      "https://docs.anthropic.com/en/docs/claude-code/getting-started";
    license = licenses.unfree;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux ++ platforms.darwin;
    mainProgram = "claude";
  };
}
