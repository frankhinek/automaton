{ lib, stdenvNoCC, fetchurl }:

let
  version = "2.1.270";
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
    "darwin-arm64" = "sha256-pQa22XCkz0T2q9tTqB3c1dOwzgQqlcUC/p0flGvbiAc=";
    "darwin-x64" = "sha256-s+4yN6AZuKWrswCPHH3dRilaDm5lq5RUWnnJuZfciSg=";
    "linux-arm64" = "sha256-e/nzOswSTfmrzPbyNmOXqCp0A3jVNfoS1Cb6d/28mUY=";
    "linux-x64" = "sha256-OmJKWnzXm7rU0yvX2zbxGX7PRYvFvx4q7YGDSgGtPvA=";
    "linux-arm64-musl" = "sha256-BnsyLfyg7YFSG1Yu8Fgl6L4oLutcg0QeS+gkQVVy28A=";
    "linux-x64-musl" = "sha256-OPmDOP8jr85JxmyDrFfqI4+E5/TowXrnzHSz7q7popk=";
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
