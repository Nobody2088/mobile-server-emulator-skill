#!/usr/bin/env bash
# triage-client.sh — APK fingerprint: engine, network stack, redirect hint
# Usage: bash triage-client.sh <apk_path> [--dry-run]

set -euo pipefail

DRY_RUN=false
APK=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) DRY_RUN=true; shift ;;
    -*) echo "Unknown option: $1" >&2; exit 1 ;;
    *)
      if [[ -z "$APK" ]]; then APK="$1"; else echo "Unexpected arg: $1" >&2; exit 1; fi
      shift
      ;;
  esac
done

if [[ "$DRY_RUN" == "true" ]] && [[ -z "$APK" || ! -f "$APK" ]]; then
  cat <<'EOF'
{
  "dry_run": true,
  "package": "com.example.game",
  "engine": "unity-il2cpp",
  "has_il2cpp": true,
  "network_hints": ["okhttp", "socket"],
  "config_urls": ["https://api.example.com"],
  "recommended_path": "il2cpp_dns_first"
}
EOF
  exit 0
fi

if [[ -z "$APK" ]]; then
  echo "Usage: bash triage-client.sh <apk_path> [--dry-run]" >&2
  exit 1
fi

if [[ ! -f "$APK" ]]; then
  echo "APK not found: $APK" >&2
  exit 1
fi

WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT

unzip -l "$APK" > "$WORK/listing.txt" 2>/dev/null || {
  echo "Failed to read APK as zip: $APK" >&2
  exit 1
}

PACKAGE=""
if command -v aapt >/dev/null 2>&1; then
  PACKAGE=$(aapt dump badging "$APK" 2>/dev/null | sed -n "s/^package: name='\([^']*\)'.*/\1/p" | head -1)
fi
if [[ -z "$PACKAGE" ]] && command -v apkanalyzer >/dev/null 2>&1; then
  PACKAGE=$(apkanalyzer manifest application-id "$APK" 2>/dev/null || true)
fi

HAS_IL2CPP=false
ENGINE="unknown"
if grep -q 'lib/.*/libil2cpp\.so' "$WORK/listing.txt"; then
  HAS_IL2CPP=true
  ENGINE="unity-il2cpp"
elif grep -q 'lib/.*/libcocos2d' "$WORK/listing.txt" || grep -qi 'cocos' "$WORK/listing.txt"; then
  ENGINE="cocos"
elif grep -q 'classes\.dex' "$WORK/listing.txt"; then
  ENGINE="native-java"
fi

NETWORK_HINTS=()
grep -qi 'okhttp' "$WORK/listing.txt" && NETWORK_HINTS+=("okhttp")
grep -qi 'retrofit' "$WORK/listing.txt" && NETWORK_HINTS+=("retrofit")
grep -qi 'websocket' "$WORK/listing.txt" && NETWORK_HINTS+=("websocket")
grep -q 'lib/.*/libil2cpp\.so' "$WORK/listing.txt" && NETWORK_HINTS+=("socket")

CONFIG_URLS=()
if command -v unzip >/dev/null 2>&1; then
  unzip -p "$APK" 'assets/*' 2>/dev/null | grep -oE 'https?://[a-zA-Z0-9./_-]+' | sort -u | head -20 > "$WORK/urls.txt" || true
  while IFS= read -r u; do CONFIG_URLS+=("$u"); done < "$WORK/urls.txt" 2>/dev/null || true
fi

RECOMMENDED="capture_first"
case "$ENGINE" in
  unity-il2cpp) RECOMMENDED="il2cpp_dns_first" ;;
  cocos) RECOMMENDED="assets_config_first" ;;
  native-java) RECOMMENDED="smali_http_first" ;;
esac

# JSON output
HINTS_JSON=$(printf '%s\n' "${NETWORK_HINTS[@]:-}" | jq -R . | jq -s . 2>/dev/null || echo '[]')
URLS_JSON=$(printf '%s\n' "${CONFIG_URLS[@]:-}" | jq -R . | jq -s . 2>/dev/null || echo '[]')

if command -v jq >/dev/null 2>&1; then
  jq -n \
    --arg package "${PACKAGE:-unknown}" \
    --arg engine "$ENGINE" \
    --argjson has_il2cpp "$HAS_IL2CPP" \
    --argjson network_hints "$HINTS_JSON" \
    --argjson config_urls "$URLS_JSON" \
    --arg recommended_path "$RECOMMENDED" \
    --arg apk "$APK" \
    '{package: $package, engine: $engine, has_il2cpp: $has_il2cpp, network_hints: $network_hints, config_urls: $config_urls, recommended_path: $recommended_path, apk: $apk}'
else
  cat <<EOF
{
  "package": "${PACKAGE:-unknown}",
  "engine": "$ENGINE",
  "has_il2cpp": $HAS_IL2CPP,
  "recommended_path": "$RECOMMENDED",
  "apk": "$APK"
}
EOF
fi
