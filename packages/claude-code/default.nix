{ lib, stdenvNoCC, fetchurl }:

let
  version = "2.1.71";
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
    "darwin-arm64" = "sha256-89gSnsfdrxWMEOGT31RkIUmdabf0TsLwtnw/5U9gHLk=";
    "darwin-x64" = "sha256-qP8hACKGCxVn01+6WCLZvkp0xCKWLi4yw59BFnltV8g=";
    "linux-arm64" = "sha256-ribkpWVCOPCmhNX9mmv1kjIbBuuI6oNDQ7J18xDjm+o=";
    "linux-x64" = "sha256-YQAuX1xBkOmndb2c+Q5X//PwN5+yyO3GU6wJQqNHur0=";
    "linux-arm64-musl" = "sha256-4iI6p60Gwhb6aBmW+lE4jBqLqQzw1c5D+OuqphjSs7E=";
    "linux-x64-musl" = "sha256-RulBpvbzVLR2RMsTLzOi9VqfxR/YTsQvzwNVBUqnmXQ=";
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
