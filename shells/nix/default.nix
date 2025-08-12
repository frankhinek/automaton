{
  inputs,
  mkShell,
  pkgs,
  system,
  ...
}:
mkShell {
  packages = with pkgs; [
    deadnix
    hydra-check
    nix-inspect
    nix-bisect
    nix-diff
    nix-health
    nix-index
    nix-melt
    nix-output-monitor
    nix-prefetch-git
    nix-search-cli
    nix-tree
    nix-update
    nixpkgs-hammering
    nixpkgs-lint
    nixpkgs-review
    snowfallorg.flake
    statix

    # Adds all the packages required for the pre-commit checks
    inputs.self.checks.${system}.pre-commit-hooks.enabledPackages
  ];

  shellHook = ''
    ${inputs.self.checks.${system}.pre-commit-hooks.shellHook}

    printf "\n    \033[1;35m🔨 Nix DevShell\033[0m\n\n"
  '';
}
