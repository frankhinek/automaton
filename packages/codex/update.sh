#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq nix-prefetch

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_NIX="$SCRIPT_DIR/default.nix"
GITHUB_REPO="openai/codex"
PLATFORM="aarch64-apple-darwin"

replace_in_file() {
    local expression="$1"
    local file="$2"
    local tmp
    tmp="$(mktemp)"
    sed "$expression" "$file" >"$tmp"
    mv "$tmp" "$file"
}

LATEST_TAG="$(
    curl -fsSL "https://api.github.com/repos/$GITHUB_REPO/releases" |
        jq -r '[ .[]
            | select(.prerelease | not)
            | .tag_name
            | select(test("^rust-v[0-9]+\\.[0-9]+\\.[0-9]+$"))
          ][0] // empty'
)"

if [[ -z $LATEST_TAG ]]; then
    echo "Unable to find latest stable rust-vX.Y.Z release tag for $GITHUB_REPO" >&2
    exit 1
fi

LATEST_VERSION="${LATEST_TAG#rust-v}"
echo "Latest version: $LATEST_VERSION"

CURRENT_VERSION="$(
    sed -n 's/^  version = "\([^"]*\)";$/\1/p' "$DEFAULT_NIX" | head -n 1
)"
CURRENT_VERSION="${CURRENT_VERSION:-unknown}"
echo "Current version: $CURRENT_VERSION"

if [[ $LATEST_VERSION == "$CURRENT_VERSION" ]]; then
    echo "Already up to date!"
    exit 0
fi

echo "Fetching source hash..."
SRC_URL="https://github.com/$GITHUB_REPO/releases/download/$LATEST_TAG/codex-${PLATFORM}.tar.gz"
SRC_HASH=$(nix-prefetch-url "$SRC_URL" 2>/dev/null | tail -n 1)
SRC_HASH_SRI=$(nix hash to-sri --type sha256 "$SRC_HASH")

echo "Updating default.nix..."
replace_in_file "s/^  version = \".*\";/  version = \"$LATEST_VERSION\";/" "$DEFAULT_NIX"
replace_in_file "s|\"$PLATFORM\" = .*;|\"$PLATFORM\" = \"$SRC_HASH_SRI\";|" "$DEFAULT_NIX"

echo "Updated codex to version $LATEST_VERSION"
echo "New source hash: $SRC_HASH_SRI"
echo ""
echo "Please test the build with:"
echo "  nix build .#codex --impure"
