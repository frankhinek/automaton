{ lib, stdenvNoCC, fetchurl }:

let
  version = "2.1.75";
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
    "darwin-arm64" = "sha256-jFQaXpJO2iBw6vFwKkgEevZxxN/2oRpediB2YUoIJnU=";
    "darwin-x64" = "sha256-gskLkaChj2AZH4F7m0IwTYsX2+11eVtxXEH0/f5MeC0=";
    "linux-arm64" = "sha256-7I9Pf3u1BhHa5wwQmnbuHaajq0VRHGXxF98hWEjsyQU=";
    "linux-x64" = "sha256-MosKQpwFoE+REVfYhr5RI88YJKGbqMofnVlMAE6sMsk=";
    "linux-arm64-musl" = "sha256-ei+slGgXrsFWXX0xvFU5hNuuZfcCS3rxtiGgG9YgpBs=";
    "linux-x64-musl" = "sha256-uiX3jnszfdMUef2hIDIFsgghxp9Dnwh1lxDXTbJjzek=";
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
