#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl nix unzip

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

parse_appcast() {
    local item_xml
    local url
    local version

    item_xml="$(sed -n '/<item>/,/<\/item>/{p; /<\/item>/q;}')"
    if [[ -z $item_xml ]]; then
        echo "Unable to find latest item in appcast" >&2
        return 1
    fi

    url="$(
        sed -n 's/.*<enclosure[^>]*url="\([^"]*\)".*/\1/p' <<<"$item_xml" |
            sed -n '1p'
    )"
    if [[ -z $url ]]; then
        echo "Missing enclosure URL in appcast" >&2
        return 1
    fi

    version="$(
        sed -n 's|.*<sparkle:shortVersionString>\([^<]*\)</sparkle:shortVersionString>.*|\1|p' <<<"$item_xml" |
            sed -n '1p'
    )"
    if [[ -z $version ]]; then
        version="$(
            sed -n 's/.*sparkle:shortVersionString="\([^"]*\)".*/\1/p' <<<"$item_xml" |
                sed -n '1p'
        )"
    fi
    if [[ -z $version && $url =~ -darwin-arm64-([0-9.]+)\.zip(\?.*)?$ ]]; then
        version="${BASH_REMATCH[1]}"
    fi
    if [[ ! $version =~ ^[0-9]+(\.[0-9]+)+$ ]]; then
        echo "Unable to derive valid version from appcast: ${version:-missing}" >&2
        return 1
    fi

    printf '%s\n%s\n' "$version" "$url"
}

read_latest_release() {
    curl -fsSL "$APPCAST_URL" | parse_appcast
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

    if ! curl -fsSL "$url" -o "$archive_path"; then
        echo "Failed to fetch source: $url" >&2
        return 1
    fi
    mkdir -p "$unpack_dir"
    unzip -q "$archive_path" -d "$unpack_dir"

    nix hash path "$unpack_dir"
}

if [[ ${1:-} == "--parse-appcast" ]]; then
    parse_appcast
    exit
fi

CURRENT_VERSION="$(
    sed -n 's/^  version = "\([^"]*\)";$/\1/p' "$DEFAULT_NIX" | sed -n '1p'
)"
CURRENT_VERSION="${CURRENT_VERSION:-unknown}"
printf 'Current version: %s\n' "$CURRENT_VERSION"

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

printf 'Latest version:  %s\n' "$LATEST_VERSION"

if [[ $LATEST_VERSION == "$CURRENT_VERSION" ]]; then
    echo "Already up to date!"
    exit 0
fi

echo "Fetching source..."
SRC_HASH_SRI="$(prefetch_fetchzip_hash "$SRC_URL")"
if [[ $SRC_HASH_SRI != sha256-* ]]; then
    SRC_HASH_SRI="$(nix hash to-sri --type sha256 "$SRC_HASH_SRI")"
fi

echo "Updating default.nix..."
replace_in_file "s/^  version = \".*\";/  version = \"$LATEST_VERSION\";/" "$DEFAULT_NIX"
replace_in_file "s|^    hash = \"sha256-[^\"]*\";|    hash = \"$SRC_HASH_SRI\";|" "$DEFAULT_NIX"

echo ""
echo "Updated codex-app: $CURRENT_VERSION -> $LATEST_VERSION"
echo ""
echo "Please test the build with:"
echo "  nix build .#codex-app --impure"
