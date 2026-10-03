#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq nix-prefetch

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_NIX="$SCRIPT_DIR/default.nix"
GITHUB_REPO="openai/codex"
PLATFORM="aarch64-apple-darwin"
SYSTEM="aarch64-darwin"

replace_in_file() {
    local expression="$1"
    local file="$2"
    local tmp
    tmp="$(mktemp)"
    sed "$expression" "$file" >"$tmp"
    mv "$tmp" "$file"
}

prefetch_sri() {
    local url="$1"
    local hash
    hash="$(nix-prefetch-url "$url" 2>/dev/null | tail -n 1)"
    if [[ -z $hash ]]; then
        echo "Failed to prefetch $url" >&2
        exit 1
    fi
    nix hash to-sri --type sha256 "$hash"
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

RELEASE_URL="https://github.com/$GITHUB_REPO/releases/download/$LATEST_TAG"

# The complete package tarball bundles codex, codex-code-mode-host, rg and the
# codex-resources tree under one codex-package.json manifest. Codex >= 0.157.0
# needs that whole layout next to its executable to start its daemon.
echo "Fetching codex-package source hash..."
PACKAGE_HASH_SRI="$(prefetch_sri "$RELEASE_URL/codex-package-${PLATFORM}.tar.gz")"

echo "Updating default.nix..."
replace_in_file "s/^  version = \".*\";/  version = \"$LATEST_VERSION\";/" "$DEFAULT_NIX"
replace_in_file "s|\"$SYSTEM\" = \"sha256-[^\"]*\";|\"$SYSTEM\" = \"$PACKAGE_HASH_SRI\";|" "$DEFAULT_NIX"

# sed is silent when nothing matches, so make a missed hash fail loudly.
if ! grep -qF "\"$PACKAGE_HASH_SRI\"" "$DEFAULT_NIX"; then
    echo "Failed to write the $SYSTEM hash into $DEFAULT_NIX" >&2
    exit 1
fi

echo "Updated codex to version $LATEST_VERSION"
echo "New codex-package hash: $PACKAGE_HASH_SRI"
echo ""
echo "Please test the build with:"
echo "  nix build .#codex --impure"
echo ""
echo "After applying the updated configuration, update the managed daemon with:"
echo "  codex app-server daemon update --from-cli"
