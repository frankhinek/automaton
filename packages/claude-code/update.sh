#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq nix-prefetch

set -euo pipefail

# Get the directory of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Fetch the latest version from npm
LATEST_VERSION=$(curl -s https://registry.npmjs.org/@anthropic-ai/claude-code/latest | jq -r '.version')
echo "Latest version: $LATEST_VERSION"

# Get the current version from default.nix
CURRENT_VERSION=$(grep -oP 'version = "\K[^"]+' "$SCRIPT_DIR/default.nix" || echo "unknown")
echo "Current version: $CURRENT_VERSION"

if [ "$LATEST_VERSION" = "$CURRENT_VERSION" ]; then
    echo "Already up to date!"
    exit 0
fi

# Fetch the source hash
echo "Fetching source hash..."
SRC_URL="https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-${LATEST_VERSION}.tgz"
SRC_HASH=$(nix-prefetch-url "$SRC_URL" 2>/dev/null | tail -n 1)
# SRC_HASH_SRI=$(nix hash convert --hash-algo sha256 --to sri "$SRC_HASH")
SRC_HASH_SRI=$(nix hash to-sri --type sha256 "$SRC_HASH")

# Update default.nix
echo "Updating default.nix..."
sed -i "s/version = \".*\"/version = \"$LATEST_VERSION\"/" default.nix
sed -i "s|hash = \".*\"|hash = \"$SRC_HASH_SRI\"|" default.nix

echo "Updated claude-code to version $LATEST_VERSION"
echo "New source hash: $SRC_HASH_SRI"
echo ""
echo "Please test the build with:"
echo "  nix build .#claude-code --impure"
