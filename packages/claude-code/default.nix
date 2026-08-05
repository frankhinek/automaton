{ lib, stdenvNoCC, fetchurl }:

let
  version = "2.1.222";
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
    "darwin-arm64" = "sha256-xmpsxvougUW7Gm53gx8sr0uDaQ/wRlBQDfpuLAXKmXw=";
    "darwin-x64" = "sha256-Nr/GSColcw27HO5yWJ5SLGbEWk3J6/3Yp2qBE7AbYYg=";
    "linux-arm64" = "sha256-oEvgqNf+AllXGrdBHVHYVljXGkomzmK2DJCCkDcuYBY=";
    "linux-x64" = "sha256-EMqujyK5FcJr//DgE6TUVgjE8a4odYNiZWkVb0R3MOU=";
    "linux-arm64-musl" = "sha256-o8PjICrohCpenStM4dzqn6ANTgrie1s+jXeDMro7sjw=";
    "linux-x64-musl" = "sha256-4LD7QAXhrA687hNiVMY4ci8cSeFxoj0IQ8YF1yqskCk=";
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
