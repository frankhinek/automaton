{ lib, stdenvNoCC, fetchzip, makeWrapper }:

let
  version = "26.623.101652";

  platform = if stdenvNoCC.hostPlatform.isDarwin
  && stdenvNoCC.hostPlatform.isAarch64 then
    "aarch64-darwin"
  else
    throw "codex-app: unsupported platform ${stdenvNoCC.hostPlatform.system}";
in stdenvNoCC.mkDerivation {
  pname = "codex-app";
  inherit version;

  src = fetchzip {
    url =
      "https://persistent.oaistatic.com/codex-app-prod/Codex-darwin-arm64-${version}.zip";
    hash = "sha256-jb9mzwmP/u2Ej1NtiDl9QQEqbSPA8XVA0iYFOzKBliY=";
    stripRoot = false;
  };

  nativeBuildInputs = [ makeWrapper ];

  dontFixup = stdenvNoCC.hostPlatform.isDarwin;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications" "$out/bin"
    cp -R "Codex.app" "$out/Applications/Codex.app"

    # Keep user profile and extensions scoped to a dedicated directory.
    makeWrapper "$out/Applications/Codex.app/Contents/MacOS/Codex" "$out/bin/codex-app" \
      --add-flags "--user-data-dir ''${XDG_STATE_HOME:-$HOME/.local/state}/codex-app-nix/user-data" \
      --add-flags "--extensions-dir ''${XDG_STATE_HOME:-$HOME/.local/state}/codex-app-nix/extensions"

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "OpenAI's Codex desktop app for managing coding agents";
    homepage = "https://openai.com/codex";
    license = licenses.unfree;
    maintainers = with maintainers; [ ];
    platforms = [ platform ];
    mainProgram = "codex-app";
  };
}
