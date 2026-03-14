#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl python3 nix nix-prefetch

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

CURRENT_VERSION="$(
    sed -n 's/^  version = "\([^"]*\)";$/\1/p' "$DEFAULT_NIX" | sed -n '1p'
)"
CURRENT_VERSION="${CURRENT_VERSION:-unknown}"
echo "Current version: $CURRENT_VERSION"

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

if [[ $LATEST_VERSION == "$CURRENT_VERSION" ]]; then
    echo "Already up to date!"
    exit 0
fi

echo "Fetching source hash..."
SRC_HASH="$(nix-prefetch-url --unpack "$SRC_URL" 2>/dev/null | sed -n '$p')"
SRC_HASH_SRI="$(nix hash convert --hash-algo sha256 --to sri "$SRC_HASH")"

echo "Updating default.nix..."
replace_in_file "s/^  version = \".*\";/  version = \"$LATEST_VERSION\";/" "$DEFAULT_NIX"
replace_in_file "s|^    hash = \"sha256-[^\"]*\";|    hash = \"$SRC_HASH_SRI\";|" "$DEFAULT_NIX"

echo ""
echo "Updated codex-app to version $LATEST_VERSION"
echo "New source hash: $SRC_HASH_SRI"
echo ""
echo "Please test the build with:"
echo "  nix build .#codex-app --impure"
