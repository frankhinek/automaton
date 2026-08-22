{ lib, stdenvNoCC, fetchurl }:

let
  version = "2.1.240";
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
    "darwin-arm64" = "sha256-iRfgHJnqDObtiHoXKaTNppPHWP5UJ0e+cXVph7FFx3I=";
    "darwin-x64" = "sha256-JEpKoWT4GtFVArxk20ZTwAJdVR7LsZeRDOJDs8uhFak=";
    "linux-arm64" = "sha256-cr5lxD0dtI6Rq75lJUA38p+3iH2EajiQ3NSJCwAmVJM=";
    "linux-x64" = "sha256-E4YWnad94ZplXweoargPV3WYOlDrDJwnp9rxbnMgMi0=";
    "linux-arm64-musl" = "sha256-9MD8gcrVVl8UfcJMFEv2fi+nZSqBomVfmHZ43SEZFe4=";
    "linux-x64-musl" = "sha256-jZqrLe6daUwTmOFXkBFH30fcFYAj6ZaYD4SSwkFpaa8=";
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
