{ lib, stdenvNoCC, fetchurl }:

let
  version = "2.1.143";
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
    "darwin-arm64" = "sha256-JwHGz9aEg/j68DFqG6ZIGhRVqQZFraF58MSNjDbXIu8=";
    "darwin-x64" = "sha256-vI/0zgK3ZaAzgI+1lvlSIwbL5cUNITRO2HUsCJZvNiw=";
    "linux-arm64" = "sha256-MujtxKXDxB0YYHx10bjnvsZDMwwD4ma+Rqw7QaRGxOs=";
    "linux-x64" = "sha256-91/cP/nZzUlLhhkvnjSbXFxtOXDtTVzVx7MwxaKx3MQ=";
    "linux-arm64-musl" = "sha256-5okD7Fbd1VYLsIIMlsj3pBk+fqtiNu3lbLLgX0UM5E8=";
    "linux-x64-musl" = "sha256-5MuFiO1uOPmSC9qiYRJj1KCw0RMA8dI5Rd8jT99eJ4o=";
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
