#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
UPDATER="$SCRIPT_DIR/update.sh"

assert_parse() {
    local expected_version="$1"
    local expected_url="$2"
    local fixture="$3"
    local parsed

    mapfile -t parsed < <(bash "$UPDATER" --parse-appcast <<<"$fixture")
    if [[ ${parsed[0]:-} != "$expected_version" ]]; then
        echo "Expected version $expected_version, got ${parsed[0]:-missing}" >&2
        return 1
    fi
    if [[ ${parsed[1]:-} != "$expected_url" ]]; then
        echo "Expected URL $expected_url, got ${parsed[1]:-missing}" >&2
        return 1
    fi
}

current_url="https://persistent.oaistatic.com/codex-app-prod/ChatGPT-darwin-arm64-26.715.72359.zip"
assert_parse "26.715.72359" "$current_url" "
<rss xmlns:sparkle=\"http://www.andymatuschak.org/xml-namespaces/sparkle\">
  <channel>
    <item>
      <sparkle:shortVersionString>26.715.72359</sparkle:shortVersionString>
      <enclosure url=\"$current_url\" />
    </item>
  </channel>
</rss>
"

legacy_url="https://persistent.oaistatic.com/codex-app-prod/Codex-darwin-arm64-26.623.141536.zip"
assert_parse "26.623.141536" "$legacy_url" "
<rss xmlns:sparkle=\"http://www.andymatuschak.org/xml-namespaces/sparkle\">
  <channel>
    <item>
      <enclosure url=\"$legacy_url\" sparkle:shortVersionString=\"26.623.141536\" />
    </item>
  </channel>
</rss>
"

assert_parse "26.715.72359" "$current_url" "
<rss>
  <channel>
    <item>
      <enclosure url=\"$current_url\" />
    </item>
  </channel>
</rss>
"

echo "All codex-app updater tests passed."
