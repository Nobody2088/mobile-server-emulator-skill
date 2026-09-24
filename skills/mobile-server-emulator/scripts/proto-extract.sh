#!/usr/bin/env bash
# proto-extract.sh — scan jadx/apktool output for Protobuf hints
# Usage: bash proto-extract.sh --jadx-dir DIR [--apktool-dir DIR] [--out DIR]

set -euo pipefail

JADX_DIR=""
APKTOOL_DIR=""
OUT=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --jadx-dir) JADX_DIR="$2"; shift 2 ;;
    --apktool-dir) APKTOOL_DIR="$2"; shift 2 ;;
    --out) OUT="$2"; shift 2 ;;
    *) echo "Unknown: $1" >&2; exit 1 ;;
  esac
done

if [[ -z "$JADX_DIR" ]] || [[ ! -d "$JADX_DIR" ]]; then
  echo "Usage: bash proto-extract.sh --jadx-dir DIR [--out DIR]" >&2
  exit 1
fi

OUT="${OUT:-$(dirname "$JADX_DIR")/proto_work}"
mkdir -p "$OUT"

REPORT="$OUT/proto_hints.txt"
: > "$REPORT"

echo "==> Scanning Protobuf patterns in $JADX_DIR" >&2

grep -r -l -E 'GeneratedMessageLite|parseFrom|toByteArray|Google\.Protobuf|protobuf' \
  "$JADX_DIR" --include='*.java' 2>/dev/null | head -100 >> "$REPORT" || true

grep -r -h -E 'https?://[a-zA-Z0-9./_-]+' "$JADX_DIR" --include='*.java' 2>/dev/null \
  | sort -u | head -50 > "$OUT/urls.txt" || true

if [[ -n "$APKTOOL_DIR" && -d "$APKTOOL_DIR" ]]; then
  find "$APKTOOL_DIR" -name '*.proto' -o -name '*protogen*' 2>/dev/null >> "$REPORT" || true
fi

HIT_COUNT=$(wc -l < "$REPORT" | tr -d ' ')

if command -v jq >/dev/null 2>&1; then
  jq -n \
    --arg out "$OUT" \
    --arg report "$REPORT" \
    --argjson hits "$HIT_COUNT" \
    '{out_dir: $out, report: $report, protobuf_file_hits: $hits}'
else
  echo "{\"out_dir\":\"$OUT\",\"protobuf_file_hits\":$HIT_COUNT}"
fi
