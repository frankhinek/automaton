{
  inputs,
  mkShell,
  pkgs,
  system,
  ...
}:
let
  inherit (inputs) snowfall-flake;
in
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
    nix-prefetch-git
    nix-search-cli
    nix-tree
    nix-update
    nixpkgs-hammering
    nixpkgs-lint
    nixpkgs-review
    snowfall-flake.packages.${system}.flake
    statix
  ];

  shellHook = ''
    printf "\n    \033[1;35m🔨 Nix DevShell\033[0m\n\n"
  '';
}
