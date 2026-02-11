#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq nix

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_NIX="$SCRIPT_DIR/default.nix"
GCS_BUCKET="https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases"

replace_in_file() {
    local expression="$1"
    local file="$2"
    local tmp
    tmp="$(mktemp)"
    sed "$expression" "$file" >"$tmp"
    mv "$tmp" "$file"
}

LATEST_VERSION="$(curl -fsSL "$GCS_BUCKET/latest")"
echo "Latest version: $LATEST_VERSION"

CURRENT_VERSION="$(
    sed -n 's/^  version = "\([^"]*\)";$/\1/p' "$DEFAULT_NIX" | head -n 1
)"
CURRENT_VERSION="${CURRENT_VERSION:-unknown}"
echo "Current version: $CURRENT_VERSION"

MANIFEST_JSON="$(curl -fsSL "$GCS_BUCKET/$LATEST_VERSION/manifest.json")"

declare -a CLAUDE_PLATFORMS=(
    "darwin-arm64"
    "darwin-x64"
    "linux-arm64"
    "linux-x64"
    "linux-arm64-musl"
    "linux-x64-musl"
)

declare -A PLATFORM_HASHES
for platform in "${CLAUDE_PLATFORMS[@]}"; do
    checksum="$(jq -r --arg platform "$platform" '.platforms[$platform].checksum // empty' <<<"$MANIFEST_JSON")"
    if [[ -z $checksum ]]; then
        echo "Missing checksum for platform: $platform" >&2
        exit 1
    fi

    PLATFORM_HASHES["$platform"]="$(nix hash convert --hash-algo sha256 --to sri "$checksum")"
done

if [[ $LATEST_VERSION == "$CURRENT_VERSION" ]]; then
    echo "Version unchanged. Refreshing platform hashes."
fi

echo "Updating default.nix..."
replace_in_file "s/^  version = \".*\";/  version = \"$LATEST_VERSION\";/" "$DEFAULT_NIX"

for platform in "${CLAUDE_PLATFORMS[@]}"; do
    sri_hash="${PLATFORM_HASHES[$platform]}"
    replace_in_file "s|\"$platform\" = \".*\";|\"$platform\" = \"$sri_hash\";|" "$DEFAULT_NIX"
    echo "  $platform => $sri_hash"
done

echo ""
echo "Updated claude-code to version $LATEST_VERSION"
echo ""
echo "Please test the build with:"
echo "  nix build .#claude-code --impure"
