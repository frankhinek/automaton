{ lib, stdenvNoCC, fetchurl }:

let
  version = "2.1.185";
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
    "darwin-arm64" = "sha256-ooDCOyEFJSGPW9hvABydvIm54HQQF1xak1UES/rcCvE=";
    "darwin-x64" = "sha256-reehPDAn91S0zayAvN1rpHD3vssnzc+La6mnDPnnevc=";
    "linux-arm64" = "sha256-24gIEiclBEVd9zFg2S+t+TcO2mhMIZzr+OYrCiYssvg=";
    "linux-x64" = "sha256-4SRjOGmfBO4OYn3uP21O16C6tI4FFL3mnG2tQ7wwOVI=";
    "linux-arm64-musl" = "sha256-6tpkIqQ3oRLRkoy56AIDGAtYs9DAxq7h7bbwQf2jlBU=";
    "linux-x64-musl" = "sha256-XxLuoeP9Nb+j912wZHGJvf5k9Fqw1p52pCfTjOaE3Tg=";
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
