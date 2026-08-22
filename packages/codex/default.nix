{ lib, stdenvNoCC, fetchurl, makeWrapper, installShellFiles, ripgrep }:

let
  version = "0.149.0";

  platform = if stdenvNoCC.hostPlatform.isDarwin
  && stdenvNoCC.hostPlatform.isAarch64 then
    "aarch64-apple-darwin"
  else
    throw "codex: unsupported platform ${stdenvNoCC.hostPlatform.system}";

  sourceHashes = {
    "aarch64-apple-darwin" = {
      codex = "sha256-DO9Plimve2vMS03irbYzN9HnegCoEeZigdpTVuPnT8Y=";
      codeModeHost = "sha256-7WpqCJxQ5yfvHwZC7nwGEbphHXbXICkxagUTvpG/skQ=";
    };
  };

  hashes = sourceHashes.${platform};

  # Shipped as its own release asset. Codex fails closed without it, so it has
  # to be installed alongside the main binary rather than fetched at runtime.
  codeModeHostSrc = fetchurl {
    url =
      "https://github.com/openai/codex/releases/download/rust-v${version}/codex-code-mode-host-${platform}.tar.gz";
    hash = hashes.codeModeHost;
  };
in stdenvNoCC.mkDerivation {
  pname = "codex";
  inherit version;

  src = fetchurl {
    url =
      "https://github.com/openai/codex/releases/download/rust-v${version}/codex-${platform}.tar.gz";
    hash = hashes.codex;
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

    # Codex resolves helper programs relative to its own executable
    # (InstallContext::from_exe), so the code-mode host must be a sibling of
    # $out/libexec/codex. Without it Code Mode fails closed and no tool calls
    # work at all.
    tar -xzf "${codeModeHostSrc}" -C "$tmpdir"

    code_mode_host_bin="$tmpdir/codex-code-mode-host-${platform}"
    if [ ! -f "$code_mode_host_bin" ]; then
      echo "codex-code-mode-host binary not found in archive"
      exit 1
    fi

    install -Dm755 "$code_mode_host_bin" "$out/libexec/codex-code-mode-host"

    # Upstream bundles ripgrep; codex shells out to `rg` for file search.
    makeWrapper "$out/libexec/codex" "$out/bin/codex" \
      --prefix PATH : ${lib.makeBinPath [ ripgrep ]} \
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
