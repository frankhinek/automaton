{ lib, stdenvNoCC, fetchurl }:

let
  version = "2.1.218";
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
    "darwin-arm64" = "sha256-cauv9ZMSyam2odgYNlBItC5OlcxSGoI2YO3tPgiA2bc=";
    "darwin-x64" = "sha256-mGK3Sgg+ik7VcvmcvUiVGF4N1aCmAa/7D7jkPY0fQOY=";
    "linux-arm64" = "sha256-KV/TBIG9A7OEUP3sKm4lu2RywgdPBLDEpWbNWYjyML8=";
    "linux-x64" = "sha256-4SBxdRqTNrivEBLBAzWP8ErBj5qv9Kc4z/e6XN+vY/I=";
    "linux-arm64-musl" = "sha256-78quSPj1N6DppHtDF6X4wYRwbJnd2MoKmiE5Hip2bvg=";
    "linux-x64-musl" = "sha256-YphikydxU/Xbl0BM9+PpbeE28Cwo95zNXHvJl2YiTbQ=";
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
