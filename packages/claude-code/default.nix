{ lib, stdenvNoCC, fetchurl }:

let
  version = "2.1.87";
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
    "darwin-arm64" = "sha256-gLUVYtsaUb+2VK7B/qagQQbaoLwVJdiMnHR0H/XZRpo=";
    "darwin-x64" = "sha256-waTN4p505MOVLq1p+Qo3ojiKoJfXxWeoHKNmmjCekiY=";
    "linux-arm64" = "sha256-GTxenAkerd4wL6I69GyNZGtyY/dPoG7TJ0blBL0J3xg=";
    "linux-x64" = "sha256-saW4lGmGKt7g5NwoyrWoMUvE0BF+Gasmp7f/fOm1m9U=";
    "linux-arm64-musl" = "sha256-OOVtSmJ3j0KbHKqHWkpuU9uO2iVgkfWK+1zyBD5JITE=";
    "linux-x64-musl" = "sha256-q6LDqJJ8U/mBpK0rGJFbKhoVEbO047XoeX0j27C/Xuo=";
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
