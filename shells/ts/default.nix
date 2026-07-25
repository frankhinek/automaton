{ mkShell, pkgs, ... }:
mkShell {
  packages = with pkgs; [
    bun
    nix-unstable.nodejs_24
    nodePackages.typescript
    nodePackages.typescript-language-server
    nodePackages.pnpm
  ];

  shellHook = ''
    echo "TypeScript development environment loaded!"
    echo "Node.js $(node --version)"
    echo "Bun $(bun --version)"
    echo "pnpm $(pnpm --version)"
    echo "TypeScript $(tsc --version)"
  '';
}
