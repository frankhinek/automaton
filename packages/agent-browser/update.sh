#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq nix

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_NIX="$SCRIPT_DIR/default.nix"
GITHUB_REPO="vercel-labs/agent-browser"
PLATFORM="darwin-arm64"
ASSET_NAME="agent-browser-$PLATFORM"

replace_in_file() {
    local expression="$1"
    local file="$2"
    local tmp
    tmp="$(mktemp)"
    sed "$expression" "$file" >"$tmp"
    mv "$tmp" "$file"
}

LATEST_RELEASE="$(
    curl -fsSL "https://api.github.com/repos/$GITHUB_REPO/releases/latest"
)"

LATEST_TAG="$(jq -r '.tag_name // empty' <<<"$LATEST_RELEASE")"
if [[ ! $LATEST_TAG =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Unable to find latest stable vX.Y.Z release tag for $GITHUB_REPO" >&2
    exit 1
fi

LATEST_VERSION="${LATEST_TAG#v}"
echo "Latest version: $LATEST_VERSION"

CURRENT_VERSION="$(
    sed -n 's/^  version = "\([^"]*\)";$/\1/p' "$DEFAULT_NIX" | head -n 1
)"
CURRENT_VERSION="${CURRENT_VERSION:-unknown}"
echo "Current version: $CURRENT_VERSION"

ASSET_DIGEST="$(
    jq -r --arg name "$ASSET_NAME" \
        '.assets[] | select(.name == $name) | .digest // empty' \
        <<<"$LATEST_RELEASE"
)"

if [[ -z $ASSET_DIGEST ]]; then
    echo "Unable to find release asset digest for: $ASSET_NAME" >&2
    exit 1
fi

if [[ ! $ASSET_DIGEST =~ ^sha256:[0-9a-fA-F]{64}$ ]]; then
    echo "Unexpected digest format for $ASSET_NAME: $ASSET_DIGEST" >&2
    exit 1
fi

SRC_HASH_SRI="$(
    nix hash convert --hash-algo sha256 --to sri "${ASSET_DIGEST#sha256:}"
)"

if [[ $LATEST_VERSION == "$CURRENT_VERSION" ]]; then
    echo "Version unchanged. Refreshing source hash."
fi

echo "Updating default.nix..."
replace_in_file "s/^  version = \".*\";/  version = \"$LATEST_VERSION\";/" "$DEFAULT_NIX"
replace_in_file "s|\"$PLATFORM\" = \"sha256-[^\"]*\";|\"$PLATFORM\" = \"$SRC_HASH_SRI\";|" "$DEFAULT_NIX"

echo ""
echo "Updated agent-browser to version $LATEST_VERSION"
echo "$PLATFORM hash: $SRC_HASH_SRI"
echo ""
echo "Please test the build with:"
echo "  nix build .#agent-browser --impure"
