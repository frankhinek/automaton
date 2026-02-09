{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "docs-list";
  version = "unstable-2026-02-08";

  src = fetchFromGitHub {
    owner = "frankhinek";
    repo = "agent-handbook";
    rev = "a1b188bdf8b6a6b75d69dab10d354e8cc8099b34";
    hash = "sha256-nHylNgYWXsaC51WGn84nEPIiWDLSqknMvfP1uVDhxE0=";
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
