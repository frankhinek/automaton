{ lib, stdenvNoCC, fetchurl }:

let
  version = "2.1.72";
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
    "darwin-arm64" = "sha256-xYT1E2LVYmlbxxdQ0cIZb5oODjb9BD4rxoPM/Jo6s9c=";
    "darwin-x64" = "sha256-JLn6GD5CJmQPCiFY53cCsN2GDZIFsb7H5pVgmjCciYY=";
    "linux-arm64" = "sha256-nwwQy50iLq9OxIcEA6FWGxMp3GaTA2Ezaah3/QWhFwg=";
    "linux-x64" = "sha256-tVM45/u4v30mi5G6s7KHU2Idq5Y3scypQ2afRJDth40=";
    "linux-arm64-musl" = "sha256-7HZE6hn4j8bnpGSydMPKAQljAZ7G5U/PmtqU39yW8Fs=";
    "linux-x64-musl" = "sha256-8JIwJLUwUT/Vk6tfzYIPVbk2/IxuzmWGoGnODEFTQrE=";
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
