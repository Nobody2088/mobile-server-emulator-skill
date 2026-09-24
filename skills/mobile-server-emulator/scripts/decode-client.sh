#!/usr/bin/env bash
# decode-client.sh — jadx + apktool 解包（薄封装 apk-reverse 思路）
# 用法: bash decode-client.sh <apk_path> [--name slug] [--out dir] [--skip-jadx] [--skip-apktool]

set -euo pipefail

APK=""
NAME=""
OUT=""
SKIP_JADX=false
SKIP_APKTOOL=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --name) NAME="$2"; shift 2 ;;
    --out) OUT="$2"; shift 2 ;;
    --skip-jadx) SKIP_JADX=true; shift ;;
    --skip-apktool) SKIP_APKTOOL=true; shift ;;
    -*) echo "Unknown: $1" >&2; exit 1 ;;
    *) APK="$1"; shift ;;
  esac
done

if [[ -z "$APK" ]] || [[ ! -f "$APK" ]]; then
  echo "Usage: bash decode-client.sh <apk> [--name slug] [--out dir]" >&2
  exit 1
fi

APK_DIR=$(cd "$(dirname "$APK")" && pwd)
BASE=$(basename "$APK" .apk)
SLUG="${NAME:-$BASE}"
OUT="${OUT:-$APK_DIR/${SLUG}_emu}"
mkdir -p "$OUT"

JADX_OUT="$OUT/jadx_out"
APKTOOL_OUT="$OUT/apktool_out"

if [[ "$SKIP_JADX" == "false" ]]; then
  if ! command -v jadx >/dev/null 2>&1; then
    echo "Missing jadx. Bootstrap: brew install jadx" >&2
    exit 1
  fi
  echo "==> jadx -d $JADX_OUT" >&2
  jadx -d "$JADX_OUT" "$APK" || echo "jadx finished with warnings" >&2
fi

if [[ "$SKIP_APKTOOL" == "false" ]]; then
  if ! command -v apktool >/dev/null 2>&1; then
    echo "Missing apktool. Bootstrap: brew install apktool" >&2
    exit 1
  fi
  echo "==> apktool d -> $APKTOOL_OUT" >&2
  apktool d "$APK" -o "$APKTOOL_OUT" -f
fi

SO_COUNT=0
[[ -d "$APKTOOL_OUT/lib" ]] && SO_COUNT=$(find "$APKTOOL_OUT/lib" -name '*.so' 2>/dev/null | wc -l | tr -d ' ')

if command -v jq >/dev/null 2>&1; then
  jq -n \
    --arg out "$OUT" \
    --arg jadx "$JADX_OUT" \
    --arg apktool "$APKTOOL_OUT" \
    --argjson so_count "$SO_COUNT" \
    '{out_dir: $out, jadx_dir: $jadx, apktool_dir: $apktool, so_files: $so_count}'
else
  echo "{\"out_dir\":\"$OUT\",\"jadx_dir\":\"$JADX_OUT\",\"apktool_dir\":\"$APKTOOL_OUT\",\"so_files\":$SO_COUNT}"
fi
