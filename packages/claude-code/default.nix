{ lib, stdenvNoCC, fetchurl }:

let
  version = "2.1.158";
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
    "darwin-arm64" = "sha256-U2oFF/pk1I3cvI61EaPQgCfUfgbRSIcjMqgEHXLCJ2g=";
    "darwin-x64" = "sha256-t7Myk3AvuOChGbeV1a9ReL00b7RtTX8WEzbVIfYtFFE=";
    "linux-arm64" = "sha256-mIB2daPtW3t3X36qge2jLLooELl+nbn2+Y171ljOwA4=";
    "linux-x64" = "sha256-3ScAis1CcAusV2JlLsg/9gS/muB4bU3eVdV6aGYBf74=";
    "linux-arm64-musl" = "sha256-dCMp9Dkwy7ESLrH+esoznLPftnvoPNJWhnhZ+6HnnOI=";
    "linux-x64-musl" = "sha256-VtZsib+NPo79q5ZeHcyEDZkyErQKLonHUVZ8S8YFvro=";
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
