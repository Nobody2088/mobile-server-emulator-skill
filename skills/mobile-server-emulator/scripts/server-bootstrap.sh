#!/usr/bin/env bash
# server-bootstrap.sh — 从 template 生成最小伪服务端
# 用法: bash server-bootstrap.sh --slug NAME --lang python|node --out DIR

set -euo pipefail

SLUG=""
LANG="python"
OUT=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --slug) SLUG="$2"; shift 2 ;;
    --lang) LANG="$2"; shift 2 ;;
    --out) OUT="$2"; shift 2 ;;
    *) echo "Unknown: $1" >&2; exit 1 ;;
  esac
done

if [[ -z "$SLUG" ]]; then
  echo "Usage: bash server-bootstrap.sh --slug mygame --lang python|node --out ./server" >&2
  exit 1
fi

OUT="${OUT:-./${SLUG}_server}"
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
TEMPLATE_ROOT="$SCRIPT_DIR/../templates"

if [[ ! -d "$TEMPLATE_ROOT/server-$LANG" ]]; then
  echo "Unknown lang: $LANG (use python or node)" >&2
  exit 1
fi

mkdir -p "$OUT"
cp -R "$TEMPLATE_ROOT/server-$LANG/." "$OUT/"
# Replace placeholder slug in files
if [[ "$(uname)" == "Darwin" ]]; then
  find "$OUT" -type f -exec sed -i '' "s/{{SLUG}}/$SLUG/g" {} +
else
  find "$OUT" -type f -exec sed -i "s/{{SLUG}}/$SLUG/g" {} +
fi

if command -v jq >/dev/null 2>&1; then
  jq -n --arg out "$OUT" --arg lang "$LANG" --arg slug "$SLUG" \
    '{out_dir: $out, lang: $lang, slug: $slug, next: "cd '"$OUT"' && install deps then start server"}'
else
  echo "{\"out_dir\":\"$OUT\",\"lang\":\"$LANG\"}"
fi
