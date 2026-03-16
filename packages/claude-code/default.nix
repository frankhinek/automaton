{ lib, stdenvNoCC, fetchurl }:

let
  version = "2.1.76";
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
    "darwin-arm64" = "sha256-/+ki9PSsVC9O2+6rvOKnSSMI0DTGaiQnyuxcMcObccg=";
    "darwin-x64" = "sha256-KhPZo8oP4zD9eGNBiXry5SUAZru7H9y2z9/6UM8PkP4=";
    "linux-arm64" = "sha256-QPdTwH8HDfNMqD5AD3Rqgnmj/TQ5Z6RT2fv6svPKes0=";
    "linux-x64" = "sha256-gBoIVnbD1UOSxC6OQ8RJR998UhMjVldffZJnxPItaZI=";
    "linux-arm64-musl" = "sha256-GPueI2FJvUddnFuewDP1yT0t7A3KH3s0zslv1CN5SXw=";
    "linux-x64-musl" = "sha256-8XrQ/lRIeZzap65f13Ey4AA5QhldqRVGpPXnsve/LwU=";
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
