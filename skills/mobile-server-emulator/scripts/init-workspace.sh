#!/usr/bin/env bash
# init-workspace.sh — create case directory skeleton
# Usage: bash init-workspace.sh --slug mygame --title "Title" --out ./cases/mygame

set -euo pipefail

SLUG=""
TITLE=""
OUT=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --slug) SLUG="$2"; shift 2 ;;
    --title) TITLE="$2"; shift 2 ;;
    --out) OUT="$2"; shift 2 ;;
    *) echo "Unknown: $1" >&2; exit 1 ;;
  esac
done

if [[ -z "$SLUG" || -z "$OUT" ]]; then
  echo "Usage: init-workspace.sh --slug SLUG --out DIR [--title TEXT]" >&2
  exit 1
fi

if [[ ! "$SLUG" =~ ^[a-z0-9][a-z0-9-]*$ ]]; then
  echo "slug must be lowercase letters, digits, hyphens" >&2
  exit 1
fi

TITLE="${TITLE:-$SLUG}"
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
ROOT=$(cd "$SCRIPT_DIR/.." && pwd)

mkdir -p "$OUT"/{client/apk,client/il2cpp,capture/samples,protocol,server,tunnel,logs,docs/master-data}

cp "$ROOT/templates/report/ENGAGEMENT.md" "$OUT/REPORT.md"
cp "$ROOT/templates/protocol/PACKET.md" "$OUT/protocol/PKT-000-template.md"

cat > "$OUT/client/redirect-notes.md" <<EOF
# Host mapping

| Role | Official | Target (IP or domain) | Port | Evidence |
|------|----------|----------------------|------|----------|
| update | | | | |
| cdn | | | | |
| gateway | | | | |
| login | | | | |
| zone | | | | |
| game | | | | |
EOF

cat > "$OUT/client/engine.md" <<EOF
# Engine review

triage engine:
reviewed engine:
evidence files:
EOF

if command -v jq >/dev/null 2>&1; then
  jq -n --arg out "$OUT" --arg slug "$SLUG" --arg title "$TITLE" \
    '{out_dir: $out, slug: $slug, title: $title, next: "run doctor.sh and triage-client.sh"}'
else
  echo "{\"out_dir\":\"$OUT\",\"slug\":\"$SLUG\",\"title\":\"$TITLE\"}"
fi
