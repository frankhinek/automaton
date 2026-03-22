{ lib, stdenvNoCC, fetchurl, makeWrapper }:

let
  version = "0.43.0";

  platform = if stdenvNoCC.hostPlatform.isDarwin
  && stdenvNoCC.hostPlatform.isAarch64 then
    "aarch64-darwin"
  else
    throw "conductor: unsupported platform ${stdenvNoCC.hostPlatform.system}";

  sourceByPlatform = {
    "aarch64-darwin" = {
      assetId = "01KM7APSYNZGPHXHAY5DGT2MM0";
      hash = "sha256-bRayUyLcaBCPjkOe4jnq5j3tCN06Ua8zWTyUpikPhgA=";
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
