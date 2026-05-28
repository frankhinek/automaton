{ lib, stdenvNoCC, fetchurl }:

let
  version = "2.1.153";
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
    "darwin-arm64" = "sha256-RJ2cidemOx1CfZEqe9bm8j+aezY4Zml8n6mgASVGslQ=";
    "darwin-x64" = "sha256-S5BSHGS3KMqr4iFzfOioPTYu8IUu7n14nwFPf/c86Xs=";
    "linux-arm64" = "sha256-Ynf7vqciKKBp5HGfw+X6NvFnSSR6IyHFINrpPoPpLZw=";
    "linux-x64" = "sha256-IU9gPzGUIWLayaZfGNQ7OsZGriFSQPrUgcSq1sYPLjg=";
    "linux-arm64-musl" = "sha256-UHHs6u3S1NawhfqkbhpgvvrUMhdqnsOf0QwARWQ4Ewg=";
    "linux-x64-musl" = "sha256-+ytAayREZtsXtI4oZOx8kLhS7z9AS7sdnJv5FO/uOdE=";
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
