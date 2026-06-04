{ lib, stdenvNoCC, fetchurl }:

let
  version = "2.1.162";
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
    "darwin-arm64" = "sha256-LUB90qYyQ6yQD2QzFYm5/NKaIVmnMokHCvaF9AhaF9I=";
    "darwin-x64" = "sha256-U/J0m/JOWoCyOwF9CHf2HJiUo8BiIhQVFbN6lMYFHUE=";
    "linux-arm64" = "sha256-7KKmA9/rw0JqhGnL55f535UkVzi8HCDshC/I+Ar0AQ0=";
    "linux-x64" = "sha256-lHpJsN6GiPanSm51PCR3H/Pd0Xsqba6F82ME7FFOYdE=";
    "linux-arm64-musl" = "sha256-+4b0kPhU3TaEZ3HDi4DefLzGgEvKg4pYHu0nksxYxEU=";
    "linux-x64-musl" = "sha256-voB0WFVHbx8bKD5zm3IaOJUqzKrUYJ1pc2zeOAlf23g=";
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
