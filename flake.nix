{
  description = "Automaton";

  inputs = {
    # macOS Support
    darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-24.11";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Provides pre-commit hook management for Git repositories
    git-hooks-nix.url = "github:cachix/git-hooks.nix";

    # Home Manager
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Private licensed fonts
    fonts-licensed.url = "git+ssh://git@github.com/frankhinek/fonts-licensed";
    fonts-licensed.inputs.nixpkgs.follows = "nixpkgs";

    # Weekly updating nix-index database
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    # For building system images and artifacts with nixos-generators
    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";

    # NixPkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Nix User Repository
    # nur.url = "github:nix-community/NUR";

    # Simplified Nix Flakes on the command line
    snowfall-flake.url = "github:snowfallorg/flake";

    # Snowfall Lib
    snowfall-lib.url = "github:snowfallorg/lib?ref=v3.0.3";
    snowfall-lib.inputs.nixpkgs.follows = "nixpkgs";

    # Configures format settings for multiple languages in one place
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs =
    inputs:
    let
      lib = inputs.snowfall-lib.mkLib {
        # Pass in both flake inputs and the root directory of the flake
        inherit inputs;
        src = ./.;

        snowfall = {
          meta = {
            name = "automaton";
            title = "Automaton";
          };

          namespace = "automaton";
        };
      };
    in
    lib.mkFlake {
      # Applied to all nixpkgs channels (stable, unstable, etc.)
      channels-config = {
        # Enable packages with non-free licenses (e.g., vscode, discord)
        allowUnfree = true;
      };

      # Modules that will be included in all home configurations
      homes.modules = with inputs; [
        # Enable nix-locate and command-not-found suggestions
        nix-index-database.homeModules.nix-index
      ];

      outputs-builder = channels: {
        formatter = inputs.treefmt-nix.lib.mkWrapper channels.nixpkgs ./treefmt.nix;
      };

      overlays = with inputs; [
        # nur.overlay
      ];
    };
}
