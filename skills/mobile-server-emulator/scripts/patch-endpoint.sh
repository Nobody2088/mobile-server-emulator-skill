#!/usr/bin/env bash
# patch-endpoint.sh — endpoint redirect: grep report + DNS/adb guidance
# Usage: bash patch-endpoint.sh --mode assets|dns|report --dir apktool_out [--old URL] [--new URL]

set -euo pipefail

MODE="report"
DIR=""
OLD=""
NEW="127.0.0.1"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --mode) MODE="$2"; shift 2 ;;
    --dir) DIR="$2"; shift 2 ;;
    --old) OLD="$2"; shift 2 ;;
    --new) NEW="$2"; shift 2 ;;
    --help)
      echo "Usage: patch-endpoint.sh --mode report|assets|dns --dir apktool_out"
      exit 0
      ;;
    *) echo "Unknown: $1" >&2; exit 1 ;;
  esac
done

SKILL_ROOT=$(cd "$(dirname "$0")/.." && pwd)

case "$MODE" in
  report)
    if [[ -z "$DIR" ]] || [[ ! -d "$DIR" ]]; then
      echo "Need --dir apktool_out" >&2
      exit 1
    fi
    REPORT=$(mktemp)
    grep -r -n -E 'https?://[a-zA-Z0-9./_-]+' "$DIR/assets" "$DIR/res" "$DIR/smali" 2>/dev/null | head -80 > "$REPORT" || true
    HITS=$(wc -l < "$REPORT" | tr -d ' ')
    if command -v jq >/dev/null 2>&1; then
      jq -n --arg mode "$MODE" --argjson hits "$HITS" --arg report "$REPORT" \
        '{mode: $mode, url_hits: $hits, report_file: $report}'
    else
      echo "Found $HITS URL lines — see $REPORT"
      cat "$REPORT"
    fi
    ;;
  assets)
    if [[ -z "$DIR" ]] || [[ -z "$OLD" ]]; then
      echo "assets mode needs --dir and --old URL" >&2
      exit 1
    fi
    echo "==> Replacing $OLD -> $NEW under $DIR" >&2
    find "$DIR/assets" "$DIR/res" -type f \( -name '*.json' -o -name '*.xml' -o -name '*.lua' -o -name '*.txt' \) \
      -exec grep -l "$OLD" {} \; 2>/dev/null | while read -r f; do
        sed -i '' "s|$OLD|$NEW|g" "$f" 2>/dev/null || sed -i "s|$OLD|$NEW|g" "$f"
        echo "patched: $f" >&2
      done
    echo '{"mode":"assets","status":"done"}'
    ;;
  dns)
    HOST="${OLD#https://}"; HOST="${HOST#http://}"; HOST="${HOST%%/*}"
    cat <<EOF
{
  "mode": "dns",
  "host": "$HOST",
  "target_ip": "$NEW",
  "steps": [
    "Router DNS or dnsmasq: address=/$HOST/$NEW",
    "Or adb reverse if local port: adb reverse tcp:PORT tcp:PORT",
    "See references/client-redirect.md and templates/config/hosts-patch.example"
  ]
}
EOF
    ;;
  *)
    echo "Unknown mode: $MODE" >&2
    exit 1
    ;;
esac
