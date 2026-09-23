{ lib, stdenvNoCC, fetchurl }:

let
  version = "2.1.281";
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
    "darwin-arm64" = "sha256-qSKYH287VaJR75+duqBiGl+Zy8tcpn+KeXR2zPyD9iY=";
    "darwin-x64" = "sha256-qTVcuw0pHOlI789hpu85dAFnL2T6Xl5nvKCS/tbNkIg=";
    "linux-arm64" = "sha256-3SezZDik/tFnDNKbrS/aanO2KLbaVUQ+XC9kf+btMo8=";
    "linux-x64" = "sha256-Vv49qIRYRl+yfX6Smd3bP+rVV1D7nC3nlfIzte6m3OE=";
    "linux-arm64-musl" = "sha256-T3LruwhwZlHnoiBDA3k3AGmPQEa8MfPn5ls4EGO3whA=";
    "linux-x64-musl" = "sha256-MCIKXPBihjRZng7eE6XMgU0hiAEWq/di8FmKM2Nve8o=";
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
