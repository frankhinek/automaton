#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl python3 nix unzip

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_NIX="$SCRIPT_DIR/default.nix"
APPCAST_URL="https://persistent.oaistatic.com/codex-app-prod/appcast.xml"

replace_in_file() {
    local expression="$1"
    local file="$2"
    local tmp
    tmp="$(mktemp)"
    sed "$expression" "$file" >"$tmp"
    mv "$tmp" "$file"
}

read_latest_release() {
    local appcast_xml
    appcast_xml="$(curl -fsSL "$APPCAST_URL")"

    python3 - "$appcast_xml" <<'PY'
import re
import sys
import xml.etree.ElementTree as ET

if len(sys.argv) < 2:
    raise SystemExit("Missing appcast content")

content = sys.argv[1]
if not content.strip():
    raise SystemExit("Appcast response was empty")

root = ET.fromstring(content)

channel = root.find("channel")
if channel is None:
    raise SystemExit("Unable to find RSS channel in appcast")

item = channel.find("item")
if item is None:
    raise SystemExit("Unable to find latest item in appcast")

enclosure = item.find("enclosure")
if enclosure is None:
    raise SystemExit("Unable to find enclosure in appcast item")

url = enclosure.attrib.get("url", "").strip()
if not url:
    raise SystemExit("Missing enclosure URL in appcast")

sparkle_short = enclosure.attrib.get("{http://www.andymatuschak.org/xml-namespaces/sparkle}shortVersionString", "").strip()
if sparkle_short:
    version = sparkle_short
else:
    match = re.search(r"Codex-darwin-arm64-([0-9.]+)\.zip$", url)
    if not match:
        raise SystemExit(f"Unable to derive version from URL: {url}")
    version = match.group(1)

print(version)
print(url)
PY
}

prefetch_fetchzip_hash() {
    local url="$1"
    local tmp_dir
    local archive_path
    local unpack_dir

    tmp_dir="$(mktemp -d)"
    archive_path="$tmp_dir/source.zip"
    unpack_dir="$tmp_dir/unpacked"
    trap 'rm -rf "$tmp_dir"' RETURN

    curl -fsSL "$url" -o "$archive_path"
    mkdir -p "$unpack_dir"
    unzip -q "$archive_path" -d "$unpack_dir"

    nix hash path "$unpack_dir"
}

CURRENT_VERSION="$(
    sed -n 's/^  version = "\([^"]*\)";$/\1/p' "$DEFAULT_NIX" | sed -n '1p'
)"
CURRENT_VERSION="${CURRENT_VERSION:-unknown}"
echo "Current version: $CURRENT_VERSION"
CURRENT_HASH="$(
    sed -n 's|^    hash = "\(sha256-[^\"]*\)";$|\1|p' "$DEFAULT_NIX" | sed -n '1p'
)"
CURRENT_HASH="${CURRENT_HASH:-unknown}"
echo "Current hash: $CURRENT_HASH"

mapfile -t release_info < <(read_latest_release)
if [[ ${#release_info[@]} -lt 2 ]]; then
    echo "Failed to parse latest codex-app release details from appcast." >&2
    exit 1
fi

LATEST_VERSION="${release_info[0]}"
SRC_URL="${release_info[1]}"

if [[ -z ${LATEST_VERSION:-} || -z ${SRC_URL:-} ]]; then
    echo "Failed to resolve latest codex-app release details from appcast." >&2
    exit 1
fi

echo "Latest version: $LATEST_VERSION"
echo "Source URL: $SRC_URL"

echo "Fetching source hash..."
SRC_HASH_SRI="$(prefetch_fetchzip_hash "$SRC_URL")"
if [[ $SRC_HASH_SRI != sha256-* ]]; then
    SRC_HASH_SRI="$(nix hash to-sri --type sha256 "$SRC_HASH_SRI")"
fi

if [[ $LATEST_VERSION == "$CURRENT_VERSION" && $SRC_HASH_SRI == "$CURRENT_HASH" ]]; then
    echo "Already up to date!"
    exit 0
fi

echo "Updating default.nix..."
if [[ $LATEST_VERSION != "$CURRENT_VERSION" ]]; then
    replace_in_file "s/^  version = \".*\";/  version = \"$LATEST_VERSION\";/" "$DEFAULT_NIX"
fi
if [[ $SRC_HASH_SRI != "$CURRENT_HASH" ]]; then
    replace_in_file "s|^    hash = \"sha256-[^\"]*\";|    hash = \"$SRC_HASH_SRI\";|" "$DEFAULT_NIX"
fi

echo ""
echo "Updated codex-app metadata"
echo "Version: $CURRENT_VERSION -> $LATEST_VERSION"
echo "Source hash: $CURRENT_HASH -> $SRC_HASH_SRI"
echo ""
echo "Please test the build with:"
echo "  nix build .#codex-app --impure"
