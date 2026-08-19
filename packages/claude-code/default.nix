{ lib, stdenvNoCC, fetchurl }:

let
  version = "2.1.233";
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
    "darwin-arm64" = "sha256-vEZrbN5j7a/Hc/RxofuYeH+rsx9SJAyGFs5+H1h7IS0=";
    "darwin-x64" = "sha256-izrhjfQRCYzlVwXEuxUenJfjTfVf43nHtrMSKmnw6nQ=";
    "linux-arm64" = "sha256-Qt8YQfdOmyrBPywaKoIO9rmsWy77hka7JcmpK4vWkZQ=";
    "linux-x64" = "sha256-VdKBCW9X1BHrvdlNv16f86zLfAVxPjc0jCwR1Lg7+dk=";
    "linux-arm64-musl" = "sha256-FmmTFAO5/qkgrqHC2zmPcOrgiDbKeIlvPl6FsE6aLZc=";
    "linux-x64-musl" = "sha256-VflbHtL4xStCmlM0xxAd1hcaeDaGd+D1uJkFxXDcVt4=";
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
