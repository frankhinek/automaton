{ lib, stdenvNoCC, fetchurl }:

let
  version = "2.1.147";
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
    "darwin-arm64" = "sha256-lKgVVBle3DPCWH8Qa/wuMB9FD1KgXL+u2LIPbwiCaXw=";
    "darwin-x64" = "sha256-kfWmNk2ImYYLIMNIFC+mbhjuOA5tN5s149JrZDYDxhI=";
    "linux-arm64" = "sha256-x7WwUPmkzr3Bs2mTXT9kB4tYe4aa6HicBsQ3xVnWuys=";
    "linux-x64" = "sha256-0+E0v1BNb/fbaNCm8iBsmhWm0vlAU4RRFvMwOwoNedQ=";
    "linux-arm64-musl" = "sha256-Bg8orXhXVTcWqX+YR+oZ+zpvo3E7qe2V2aPr2hnxqy4=";
    "linux-x64-musl" = "sha256-0zZYPW1l8HLeqeoYdOzraiXbFciTlptg2g7T/6Twd3o=";
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
