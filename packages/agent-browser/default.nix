{ lib, stdenvNoCC, fetchurl }:

let
  version = "0.30.1";

  platform = if stdenvNoCC.hostPlatform.isDarwin
  && stdenvNoCC.hostPlatform.isAarch64 then
    "darwin-arm64"
  else
    throw
    "agent-browser: unsupported platform ${stdenvNoCC.hostPlatform.system}";

  sourceHashes = {
    "darwin-arm64" = "sha256-/xK27YRKue+FUZzq517lbfOfjG8ESAGAtn/9H9uSrqM=";
  };
in stdenvNoCC.mkDerivation {
  pname = "agent-browser";
  inherit version;

  src = fetchurl {
    url =
      "https://github.com/vercel-labs/agent-browser/releases/download/v${version}/agent-browser-${platform}";
    hash = sourceHashes.${platform};
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 "$src" "$out/bin/agent-browser"
    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Browser automation CLI for AI agents";
    homepage = "https://agent-browser.dev";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
    platforms = [ "aarch64-darwin" ];
    mainProgram = "agent-browser";
  };
}
