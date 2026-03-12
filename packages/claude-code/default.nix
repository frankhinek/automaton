{ lib, stdenvNoCC, fetchurl }:

let
  version = "2.1.74";
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
    "darwin-arm64" = "sha256-SKB+KIfNSHkhnTGeSKxcxuIJgjjHwKvgHFejVDCUHLc=";
    "darwin-x64" = "sha256-Mfp+vUJHGUBssSP5V4HF55X3qYmWEf8akhMJJFjTRus=";
    "linux-arm64" = "sha256-v6iDiXomQzxRMqZBsy0fzgDh7/BKYb9SzZq4WurC6pU=";
    "linux-x64" = "sha256-5WE2EN7uds0yvJuOnjZNoHT82IBwX4N6TJ7h7Dj5tzs=";
    "linux-arm64-musl" = "sha256-cvS8jgFjVxESKemgJrT/Mi3V+lsngvWTaL14j3jpr3U=";
    "linux-x64-musl" = "sha256-CPvD8/bZWlgXv/dO8CFFGW4tDllHvWzFL9PqiotHpRw=";
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
