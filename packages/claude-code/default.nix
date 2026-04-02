{ lib, stdenvNoCC, fetchurl }:

let
  version = "2.1.90";
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
    "darwin-arm64" = "sha256-c8GnVwUBynQ80tdGfLRpkQNTSiE4BSpObKtTwOCdecg=";
    "darwin-x64" = "sha256-mTRnUGPqQ2BmW3pD9knJLmulz5MlcySvevGmtJB0Y5U=";
    "linux-arm64" = "sha256-FdUInufZmB+qz1Rj6r1CegEoFNn8AhE4g7sjpPOHrUo=";
    "linux-x64" = "sha256-YHTjlZmJspWKmr7GCt97RBoPbxx+ZkAav/D+VNrQT9Y=";
    "linux-arm64-musl" = "sha256-JQj6HJwFdc9vom8lYf9/D9g75ftMb57IKB39WRHUQ3E=";
    "linux-x64-musl" = "sha256-hUdG0E2xH1Q+2NODa1MWNm2WXmts+irGMS5velxLXLE=";
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
