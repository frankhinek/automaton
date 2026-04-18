{ lib, stdenvNoCC, fetchurl }:

let
  version = "2.1.114";
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
    "darwin-arm64" = "sha256-vxtNo2jaeXDw0dShZ1rOqZtvKtlPJOn4zPzHlArGeJQ=";
    "darwin-x64" = "sha256-GjA2C2JABWpYupGHyPnS6I6Ung+XDVz4H41pvGVWj2o=";
    "linux-arm64" = "sha256-lVa3TiyRLn3K75DJH9DdUJU2T4qdcTmN48XGaWErgoo=";
    "linux-x64" = "sha256-Er1LCRbesGvhf/x7LwSF4UC/ALLbPct4Rp1mcj1zwn8=";
    "linux-arm64-musl" = "sha256-IMaMMS52+4H1LNIAaxRhoO7dRweY9EubSoM61YPMwFs=";
    "linux-x64-musl" = "sha256-+7z6Il6UjZJjw5+L4pqVbqS9OkRfeaqTls3DJj6gVpA=";
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
