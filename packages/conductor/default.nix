{ lib, stdenvNoCC, fetchurl, makeWrapper }:

let
  version = "0.49.5";

  platform = if stdenvNoCC.hostPlatform.isDarwin
  && stdenvNoCC.hostPlatform.isAarch64 then
    "aarch64-darwin"
  else
    throw "conductor: unsupported platform ${stdenvNoCC.hostPlatform.system}";

  sourceByPlatform = {
    "aarch64-darwin" = {
      assetId = "01KQ0Z63RRHPXMQFX01XH25ZFD";
      hash = "sha256-LD1fDRdq8jP3zZ4gxOk/xj4qjGBjR0+sfNVsfa4CH9Y=";
    };
  };

  source = sourceByPlatform.${platform};
in stdenvNoCC.mkDerivation {
  pname = "conductor";
  inherit version;

  src = fetchurl {
    url = "https://cdn.crabnebula.app/asset/${source.assetId}";
    inherit (source) hash;
  };

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;
  dontFixup = stdenvNoCC.hostPlatform.isDarwin;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications" "$out/bin"
    tmpdir="$(mktemp -d)"
    tar -xzf "$src" -C "$tmpdir"

    if [ ! -d "$tmpdir/Conductor.app" ]; then
      echo "Conductor.app not found in archive"
      exit 1
    fi

    cp -R "$tmpdir/Conductor.app" "$out/Applications/Conductor.app"
    install -Dm755 ${./backup-conductor} "$out/bin/backup-conductor"
    install -Dm755 ${./restore-conductor} "$out/bin/restore-conductor"

    makeWrapper "$out/Applications/Conductor.app/Contents/MacOS/conductor" "$out/bin/conductor"

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Desktop app for running coding agents in parallel";
    homepage = "https://conductor.build/";
    license = licenses.unfree;
    maintainers = with maintainers; [ ];
    platforms = [ "aarch64-darwin" ];
    mainProgram = "conductor";
  };
}
