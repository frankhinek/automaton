{ mkShell, pkgs, ... }:
mkShell {
  packages = with pkgs; [
    cargo
    cargo-nextest
    clippy
    rust-analyzer
    rustc
    rustfmt
    rustPlatform.rustLibSrc
  ];

  RUST_SRC_PATH = "${pkgs.rustPlatform.rustLibSrc}";

  shellHook = ''
    printf "\n    \033[1;35m🔨 Rust DevShell\033[0m\n\n"
  '';
}
