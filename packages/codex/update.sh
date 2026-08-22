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

echo "Fetching codex source hash..."
CODEX_HASH_SRI="$(prefetch_sri "$RELEASE_URL/codex-${PLATFORM}.tar.gz")"

# codex resolves this helper relative to its own executable, so it is versioned
# and installed in lockstep with the main binary.
echo "Fetching codex-code-mode-host source hash..."
CODE_MODE_HOST_HASH_SRI="$(prefetch_sri "$RELEASE_URL/codex-code-mode-host-${PLATFORM}.tar.gz")"

echo "Updating default.nix..."
replace_in_file "s/^  version = \".*\";/  version = \"$LATEST_VERSION\";/" "$DEFAULT_NIX"
replace_in_file "s|^\( *codex = \)\"sha256-[^\"]*\";|\1\"$CODEX_HASH_SRI\";|" "$DEFAULT_NIX"
replace_in_file "s|^\( *codeModeHost = \)\"sha256-[^\"]*\";|\1\"$CODE_MODE_HOST_HASH_SRI\";|" "$DEFAULT_NIX"

echo "Updated codex to version $LATEST_VERSION"
echo "New codex hash: $CODEX_HASH_SRI"
echo "New codex-code-mode-host hash: $CODE_MODE_HOST_HASH_SRI"
echo ""
echo "Please test the build with:"
echo "  nix build .#codex --impure"
