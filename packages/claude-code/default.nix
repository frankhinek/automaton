{ lib, stdenvNoCC, fetchurl }:

let
  version = "2.1.202";
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
    "darwin-arm64" = "sha256-dBT3B4YeL+Wv7zOkZviIqNIXDlAo9enShY8dPvRf/KU=";
    "darwin-x64" = "sha256-DcV4uylAlPUEHpmgREAwrGrnI2s4flbwDUpSFIFnY70=";
    "linux-arm64" = "sha256-3l4Lso4rMkCURO1MFDHikxABwF7ScKPclsZwawaThn8=";
    "linux-x64" = "sha256-cVkCAiSYkts4BezVuGf4MfBLgSnqq9P5pb1LoWtSyDk=";
    "linux-arm64-musl" = "sha256-gEBf6tMp3WfXhrKj1JuxIXl6FXk3yZ3tri42/Md7VeY=";
    "linux-x64-musl" = "sha256-vWLUe2d7iGfjTzJkLuE/n7h60xuKz90yYwfu/+wC7Ik=";
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
