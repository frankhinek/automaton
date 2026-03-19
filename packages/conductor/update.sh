#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq nix nix-prefetch

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_NIX="$SCRIPT_DIR/default.nix"
AARCH64_LATEST_URL="https://cdn.crabnebula.app/update/melty/conductor/darwin-aarch64/latest"

replace_in_file() {
    local expression="$1"
    local file="$2"
    local tmp
    tmp="$(mktemp)"
    sed "$expression" "$file" >"$tmp"
    mv "$tmp" "$file"
}

read_latest_release() {
    local endpoint="$1"
    local latest_json
    local version
    local url
    local asset_id

    latest_json="$(curl -fsSL "$endpoint")"
    version="$(jq -r '.version // empty' <<<"$latest_json")"
    url="$(jq -r '.url // empty' <<<"$latest_json")"
    asset_id="$(sed -n 's#^.*/asset/\([^?]*\).*$#\1#p' <<<"$url")"

    if [[ -z $version || -z $url || -z $asset_id ]]; then
        echo "Failed to parse latest release from: $endpoint" >&2
        exit 1
    fi

    printf '%s\n%s\n' "$version" "$asset_id"
}

prefetch_hash_sri() {
    local asset_id="$1"
    local source_url
    local source_hash

    source_url="https://cdn.crabnebula.app/asset/${asset_id}"
    source_hash="$(nix-prefetch-url "$source_url" 2>/dev/null | tail -n 1)"

    if [[ -z $source_hash ]]; then
        echo "Failed to compute source hash for: $source_url" >&2
        exit 1
    fi

    nix hash convert --hash-algo sha256 --to sri "$source_hash"
}

CURRENT_VERSION="$(
    sed -n 's/^  version = "\([^"]*\)";$/\1/p' "$DEFAULT_NIX" | head -n 1
)"
CURRENT_VERSION="${CURRENT_VERSION:-unknown}"
echo "Current version: $CURRENT_VERSION"

mapfile -t aarch64_release < <(read_latest_release "$AARCH64_LATEST_URL")

AARCH64_VERSION="${aarch64_release[0]}"
AARCH64_ASSET_ID="${aarch64_release[1]}"
LATEST_VERSION="$AARCH64_VERSION"

echo "Latest version: $LATEST_VERSION"
echo "aarch64 asset: $AARCH64_ASSET_ID"

if [[ $LATEST_VERSION == "$CURRENT_VERSION" ]]; then
    echo "Already up to date!"
    exit 0
fi

echo "Fetching source hash..."
AARCH64_HASH_SRI="$(prefetch_hash_sri "$AARCH64_ASSET_ID")"

echo "Updating default.nix..."
replace_in_file "s/^  version = \".*\";/  version = \"$LATEST_VERSION\";/" "$DEFAULT_NIX"
replace_in_file "/\"aarch64-darwin\" = {/,/};/ s|assetId = \".*\";|assetId = \"$AARCH64_ASSET_ID\";|" "$DEFAULT_NIX"
replace_in_file "/\"aarch64-darwin\" = {/,/};/ s|hash = \"sha256-[^\"]*\";|hash = \"$AARCH64_HASH_SRI\";|" "$DEFAULT_NIX"

echo ""
echo "Updated conductor to version $LATEST_VERSION"
echo "aarch64 hash: $AARCH64_HASH_SRI"
echo ""
echo "Please test the build with:"
echo "  nix build .#conductor --impure"
