{ lib, stdenvNoCC, fetchurl }:

let
  version = "2.1.263";
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
    "darwin-arm64" = "sha256-710pCcivSfMattVIfpAxZ3e8L6wXCt/oFgcWyqiq9Pk=";
    "darwin-x64" = "sha256-qUqLIp+oXDoxbGtKNeCqIr7BqrvT0UIoJs4dEN3Ih1E=";
    "linux-arm64" = "sha256-fSXXyK5sbgCcx9rk6Bf2dBef0x+3dhvNVv7kwpArTAM=";
    "linux-x64" = "sha256-JtAgNR6BEvQAZ5Dzz85DtMnfDBux0OVCNk1kFRuB1bo=";
    "linux-arm64-musl" = "sha256-mwLoGmHVS+8+bRkLby9sSpwx5uBoRo951SDV//9rDkI=";
    "linux-x64-musl" = "sha256-ucQH42hHvLJLlTsTkPJAyECubJnhCnZHXS+txdXErco=";
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
