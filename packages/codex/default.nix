{ lib, stdenvNoCC, fetchurl, makeWrapper, installShellFiles }:

let
  version = "0.134.0";

  platform = if stdenvNoCC.hostPlatform.isDarwin
  && stdenvNoCC.hostPlatform.isAarch64 then
    "aarch64-apple-darwin"
  else
    throw "codex: unsupported platform ${stdenvNoCC.hostPlatform.system}";

  sourceHashes = {
    "aarch64-apple-darwin" =
      "sha256-eK1ILMrrDriYOzQPM6HyjIrTFbbV4xQMNMfhGcgmvBI=";
  };
in stdenvNoCC.mkDerivation {
  pname = "codex";
  inherit version;

  src = fetchurl {
    url =
      "https://github.com/openai/codex/releases/download/rust-v${version}/codex-${platform}.tar.gz";
    hash = sourceHashes.${platform};
  };

  nativeBuildInputs = [ makeWrapper installShellFiles ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/libexec" "$out/bin"

    tmpdir="$(mktemp -d)"
    tar -xzf "$src" -C "$tmpdir"

    codex_bin="$tmpdir/codex-${platform}"
    if [ ! -f "$codex_bin" ]; then
      echo "codex binary not found in archive"
      exit 1
    fi

    install -Dm755 "$codex_bin" "$out/libexec/codex"

    makeWrapper "$out/libexec/codex" "$out/bin/codex" \
      --set DISABLE_AUTOUPDATER 1 \
      --set AUTHORIZED 1 \
      --unset DEV

    runHook postInstall
  '';

  postInstall = ''
    installShellCompletion --cmd codex \
      --bash <("$out/bin/codex" completion bash) \
      --fish <("$out/bin/codex" completion fish) \
      --zsh <("$out/bin/codex" completion zsh)
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Lightweight coding agent that runs in your terminal";
    homepage = "https://github.com/openai/codex";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
    platforms = [ "aarch64-darwin" ];
    mainProgram = "codex";
  };
}
