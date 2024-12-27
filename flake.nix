{
  description = "Frank's nixos, nix-darwin, and home-manager configs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    ghostty.url = "github:ghostty-org/ghostty";

    fonts-licensed = {
      url = "git+ssh://git@github.com/frankhinek/fonts-licensed.git";
      rev = "80624e90e6eaee82ba1ad68256273cef42d39f16";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      ghostty,
      fonts-licensed,
      darwin,
      home-manager,
      nix-index-database,
      nixpkgs,
      ...
    }:

    let
      overlays = [];

      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.platforms.unix;

      nixpkgsFor = forAllSystems (
        system:
        import nixpkgs {
          inherit system;
          inherit overlays;
        }
      );
    in
    {
      nixosConfigurations = {
        freeside = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            { nixpkgs.overlays = overlays; }
            ./machines/freeside
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.frank = {
                imports = [
                  ./modules/home.nix
                  ./modules/nixos.nix
                  ./modules/neovim
                  ./modules/git
                  ./modules/gh
                  ./modules/shell.nix
                  nix-index-database.hmModules.nix-index
                ];
              };
            }
          ];
        };
      };

      darwinConfigurations = {
        wintermute = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            { nixpkgs.overlays = overlays; }
            ./machines/wintermute
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = false;
              home-manager.users.frank = {
                imports = [
                  ./modules/home.nix
                  ./modules/darwin
                  ./modules/packages.nix
                  ./modules/fonts.nix
                  ./modules/ghostty
                  ./modules/neovim
                  ./modules/git
                  ./modules/gh
                  ./modules/shell.nix
                  nix-index-database.hmModules.nix-index
                ];
              };
            }
          ];
        };
      };

      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgsFor.${system};
        in
        {
          default = pkgs.mkShellNoCC {
            buildInputs = with pkgs; [
              (writeScriptBin "dot-clean" ''
                nix-collect-garbage -d --delete-older-than 30d
              '')
              (writeScriptBin "dot-apply" ''
                if test $(uname -s) == "Linux"; then
                  sudo nixos-rebuild switch --flake .#
                fi
                if test $(uname -s) == "Darwin"; then
                  nix build "./#darwinConfigurations.$(hostname | cut -f1 -d'.').system"
                  ./result/sw/bin/darwin-rebuild switch --flake .
                fi
              '')
              (writeScriptBin "dot-sync" ''
                git pull --rebase origin main
                nix flake update
                dot-clean
                dot-apply
              '')
            ];
          };
        }
      );
    };

}
