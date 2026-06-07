{ lib, stdenvNoCC, fetchurl }:

let
  version = "2.1.168";
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
    "darwin-arm64" = "sha256-N38OztuoJGvavfMSzot8yK4RYJl7JvXtyjUqSo1h3Hg=";
    "darwin-x64" = "sha256-aI89n6CVWHjCkaWP6+nk2qBhMm2iF62nQNl8XhdjSiY=";
    "linux-arm64" = "sha256-QNUOfEV0Kqo3B/o2KNf3ZcVe1QMQi28QBRPjjTJHeqA=";
    "linux-x64" = "sha256-4vfLUEQr3uIb8mhu83JaavGHogTkbEr1wS0PbXYyZIU=";
    "linux-arm64-musl" = "sha256-onK+ejucQUlUyn6xrctYC0xECnvVRBZFloTYV+3egrw=";
    "linux-x64-musl" = "sha256-A6hxp3nPULqNAVOI+zSKjky2AtngZ420qvgi0xPvjxE=";
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
