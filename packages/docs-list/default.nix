{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "docs-list";
  version = "unstable-2026-07-06";

  src = fetchFromGitHub {
    owner = "frankhinek";
    repo = "agent-handbook";
    rev = "c4688e279f98d28a4cf72eb90b252c351ea50c55";
    hash = "sha256-iXDwwI8UJDDcHYMTDlkvys2FHVAaJk41cZTJ2MPmtto=";
  };

  sourceRoot = "source/tooling/docs-list";
  cargoHash = "sha256-JO+JUEVNbc+C1RXnNuLjcvHbO2LSXUg2f/XkAtKF8FM=";

  meta = with lib; {
    description = "docs-list CLI tool for listing project documentation files.";
    homepage = "https://github.com/frankhinek/agent-handbook";
    license = licenses.mit;
    platforms = platforms.all;
    mainProgram = "docs-list";
  };
}
