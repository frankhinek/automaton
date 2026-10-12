{ lib, stdenvNoCC, fetchurl }:

let
  version = "2.1.296";
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
    "darwin-arm64" = "sha256-ybU0Fje+y9Qj3f/FslSvtkVoKjhoy3CLvGzA57tBmTc=";
    "darwin-x64" = "sha256-pr9PML4kEFOpI/OCCtI8WZHS9awpNbOo3WTaIY2cxgM=";
    "linux-arm64" = "sha256-8fbpbg2DQrnb9B1+iCVTl6alLOPYc2rWpMa1nJti/vo=";
    "linux-x64" = "sha256-JJcuO8hZ+rK0btTB5R99YTDwbTvVUIEaEUZA3jNw0N4=";
    "linux-arm64-musl" = "sha256-sLvJNqgpMJM9fVZFCBBQ1fgnqUbParxldTg7d3oP7sA=";
    "linux-x64-musl" = "sha256-lKHMxv/JsIicayuA4gKIXIpXV2Z3U3c5japNtf2JQX8=";
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
