{ lib, stdenvNoCC, fetchurl, makeWrapper, installShellFiles }:

let
  version = "0.159.3";

  platform = if stdenvNoCC.hostPlatform.isDarwin
  && stdenvNoCC.hostPlatform.isAarch64 then
    "aarch64-apple-darwin"
  else
    throw "codex: unsupported platform ${stdenvNoCC.hostPlatform.system}";

  # Keyed by Nix system rather than the upstream triple so each entry stays on
  # one line under nixfmt, which is what update.sh's sed expects.
  sourceHashes = {
    "aarch64-darwin" = "sha256-+tV6VoHKvO8h0yKvWuyTiXXPtxG18l1M5JB+ZWFhbQc=";
  };
in stdenvNoCC.mkDerivation {
  pname = "codex";
  inherit version;

  # Upstream's "complete package" tarball (codex-package.json layoutVersion 1):
  #   bin/codex, bin/codex-code-mode-host, codex-path/rg, codex-resources/…
  # Since 0.157.0 the CLI launches a shared app-server daemon by copying this
  # whole tree into ~/.codex/packages/app-server-daemon, and it refuses to start
  # ("this CLI has no complete local package") when its executable is not
  # inside such a tree. The bare codex-<platform>.tar.gz binary is no longer
  # enough on its own.
  src = fetchurl {
    url =
      "https://github.com/openai/codex/releases/download/rust-v${version}/codex-package-${platform}.tar.gz";
    hash = sourceHashes.${stdenvNoCC.hostPlatform.system};
  };

  nativeBuildInputs = [ makeWrapper installShellFiles ];

  dontUnpack = true;

  # The Mach-O binaries are Developer ID signed and the bundled voice runtime
  # pins their sha256 in codex-resources/voice/manifest.json; stripping or
  # rewriting them would break both.
  dontStrip = true;
  dontPatchShebangs = true;

  installPhase = ''
    runHook preInstall

    # The package root has to be a directory of its own: codex discovers it as
    # the parent of the bin/ directory holding its executable
    # (InstallContext::from_exe), and the daemon installer copies the entire
    # tree verbatim, so nothing else may live in here.
    pkgdir="$out/libexec/codex"
    mkdir -p "$pkgdir" "$out/bin"
    tar -xzf "$src" -C "$pkgdir"

    # Mirror the daemon's validate_package() so a broken upstream tarball fails
    # the build instead of failing at first launch.
    for f in codex-package.json bin/codex bin/codex-code-mode-host codex-path/rg; do
      if [ ! -f "$pkgdir/$f" ]; then
        echo "codex: package is missing $f" >&2
        exit 1
      fi
    done
    for f in bin/codex bin/codex-code-mode-host codex-path/rg; do
      chmod 755 "$pkgdir/$f"
    done

    # Everything codex needs (ripgrep, code-mode host, zsh, voice runtime) is
    # resolved relative to the package root, so the wrapper only carries env.
    makeWrapper "$pkgdir/bin/codex" "$out/bin/codex" \
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
