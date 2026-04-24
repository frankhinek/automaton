{ lib, stdenvNoCC, fetchurl }:

let
  version = "2.1.119";
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
    "darwin-arm64" = "sha256-Mds0RDCdXQ+Lheh4Li3NhvMffkjBoeg9abCSaMe0+aI=";
    "darwin-x64" = "sha256-UrO3XP6AxiaYKy/7Omzhx5eCTyV9wnXPCjwywgK2o98=";
    "linux-arm64" = "sha256-OCqnPqSwf9jWmOMVm1754bhzn651BbqN3Si4pqYoGc4=";
    "linux-x64" = "sha256-zKQwU/BilJSVWWsRtv0bWc95ECrbE7rL5mmX5vrkHko=";
    "linux-arm64-musl" = "sha256-4Jv67di/3q6+Xxz5u4Hr63GDEsaP/843n7UXhiYxQ9A=";
    "linux-x64-musl" = "sha256-70GhFlOznBTbLTQ/H14qOvfrmHHGPmTetuZZGWcKTgs=";
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
