{ lib, stdenvNoCC, fetchurl }:

let
  version = "2.1.200";
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
    "darwin-arm64" = "sha256-5v1SwMcv+DZjvzy/yDO0X6q6K5qZUoYyedw8/BoEkrY=";
    "darwin-x64" = "sha256-sKTdVqkbJOGMn4O1Cn8ZmJ7Lq6PSrkv28/lfQDOoc3E=";
    "linux-arm64" = "sha256-Q0q4XNIV731c16/B0CwKlcBSE1fYgZ9wyne2tLHFJz0=";
    "linux-x64" = "sha256-JuQqMmiXnwxaO2wPN1sV3X3s+q5LsCd0OQ1qI/TNUa0=";
    "linux-arm64-musl" = "sha256-tH7Exvm2seWYfzM+KLAalJyajBGY9HvjNrqyUHp3L9Y=";
    "linux-x64-musl" = "sha256-xGHGJRzS9uvk3ExfCCOkBPFyK33HzLCTfOe8bl3Fhm8=";
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
