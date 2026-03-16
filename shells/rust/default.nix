{ mkShell, pkgs, ... }:
let
  rustToolchain = pkgs.rust-bin.stable."1.90.0".default.override {
    extensions = [ "rust-src" "rust-analyzer" ];
  };
in mkShell {
  packages = with pkgs; [ cargo-nextest cmake rustToolchain ];

  RUST_SRC_PATH = "${rustToolchain}/lib/rustlib/src/rust/library";

  shellHook = ''
    printf "\n    \033[1;35m🦀 Rust DevShell\033[0m\n\n"
  '';
}
