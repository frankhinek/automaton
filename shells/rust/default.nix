{ mkShell, pkgs, ... }:
mkShell {
  packages = with pkgs; [
    cargo
    clippy
    rust-analyzer
    rustc
    rustfmt
  ];

  shellHook = ''
    printf "\n    \033[1;35m🔨 Rust DevShell\033[0m\n\n"
  '';
}
