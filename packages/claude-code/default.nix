{ lib, stdenvNoCC, fetchurl }:

let
  version = "2.1.150";
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
    "darwin-arm64" = "sha256-L4QT6hCD8QhYeUBJahcFd1E0QQnSYftCOastRbIoXJk=";
    "darwin-x64" = "sha256-xm1XId84zOgs3gPSRPj6knaBJf4G6NHTjUv7ra9KjRc=";
    "linux-arm64" = "sha256-IFKUlUPqB24rXNpEwDGys0/DA9uY3FatZYO34KQX6+s=";
    "linux-x64" = "sha256-bAhqD1+/aE1BSLtpYpJotPUQlJjBp751es8YxR/QT0s=";
    "linux-arm64-musl" = "sha256-7EiuQM/H8P5lwG3fjUuvB/DFp9JV7SRxZ4zBdfwBljI=";
    "linux-x64-musl" = "sha256-SM9M0TqCBazhcEwyMnDmflvu0RtT5iCcSPuEkPC+kBQ=";
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
