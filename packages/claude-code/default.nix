{ lib, stdenvNoCC, fetchurl }:

let
  version = "2.1.42";
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
    "darwin-arm64" = "sha256-aQgVK/GkursT3oZkDzeVNJAFBptUHUuKOZaAK4Y6Av0=";
    "darwin-x64" = "sha256-Gk4dL5m22bKUYHveQCtnRhNP+pE7InZ+5F+/gg38wbQ=";
    "linux-arm64" = "sha256-WnXQcTKHtjZjagbOkQP/VPV4gXDy6TEvx1WRIfZJ028=";
    "linux-x64" = "sha256-UXhb0m0oljloGYMrwjoYpsDKObe3YRk/p7bpkKF/J9g=";
    "linux-arm64-musl" = "sha256-hb428YXhipoL16vIRye0Lk6pjlSaPXMRTH6zfoNV/dw=";
    "linux-x64-musl" = "sha256-+S7Ut5maDVZCMyYLEQLGzu39UXSkCuoDzhyQN/u7BJg=";
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
