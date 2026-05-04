{ lib, stdenvNoCC, fetchurl }:

let
  version = "2.1.126";
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
    "darwin-arm64" = "sha256-h6HQUBjOrfwf5ha/wQJisFA/UZhvSvLcQtHthW7T97s=";
    "darwin-x64" = "sha256-SakMR0ODqe2hExC9cffqa7kTYeyZRDtzPLUAP25wPMs=";
    "linux-arm64" = "sha256-iKbcphOkBVnzusipRqLsbmCocLkZONPfk9ysHexISMs=";
    "linux-x64" = "sha256-/OlpaNJ1Fh/2WkwZ/GQ078aXPZ9tNdw5kqK6BVPKwY4=";
    "linux-arm64-musl" = "sha256-BCu8DDYQ0AXTcWReNMS0BVuySZ96RQntZnsqiSSsWFM=";
    "linux-x64-musl" = "sha256-s/ObAAaVWOV8bTbq1rLv4BOvpXtgNEXDODdNDIc+lcA=";
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
