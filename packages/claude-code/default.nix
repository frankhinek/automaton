{ lib, stdenvNoCC, fetchurl }:

let
  version = "2.1.198";
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
    "darwin-arm64" = "sha256-q29+4QmBbt5BT3woVEZjP4BbYjqmCfQlYJpkJmRR1h4=";
    "darwin-x64" = "sha256-KAts/GDazEyu0xrxJJ5TwlnAF1lVbmBjOUTAJAXILdA=";
    "linux-arm64" = "sha256-mbUKbysfPvB7yvHlii+Yg8RwyE5CivoyGXKxqiA3Lpo=";
    "linux-x64" = "sha256-cGavQqX+kwOME69QctTANNw5KAkssSH92JLHa5S2uE0=";
    "linux-arm64-musl" = "sha256-iMs5EIXkGUV1abzFemcvc08wtCThffcyPzu7QhI46AE=";
    "linux-x64-musl" = "sha256-QokhWaA77kkpJrYWsScDE1RPelK2jTLLaA6RmEpMZlk=";
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
