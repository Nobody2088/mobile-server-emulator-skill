#!/usr/bin/env bash
# init-workspace.sh — 建立案件目录并放入报告与范围草稿
# 用法: bash init-workspace.sh --slug mygame --title "Title" --out ./cases/mygame

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

mkdir -p "$OUT"/{client/apk,capture/samples,protocol,server,tunnel,logs}

cp "$ROOT/templates/report/ENGAGEMENT.md" "$OUT/REPORT.md"
cp "$ROOT/templates/protocol/PACKET.md" "$OUT/protocol/PKT-000-template.md"

cat > "$OUT/00-scope.md" <<EOF
# 范围

结论: 待填写（允许 | 停止）
依据:
不做: 充值、官方服、公开分发

标题: $TITLE
slug: $SLUG
EOF

cat > "$OUT/client/redirect-notes.md" <<EOF
# 地址对照

| 角色 | 官方 | 现在指向 | 证据 |
|------|------|----------|------|
| 登录服 | | | |
| 游戏服 | | | |
| 资源 CDN | | | |
EOF

cat > "$OUT/client/engine.md" <<EOF
# 引擎复核

triage engine:
复核结论:
依据文件:
EOF

if command -v jq >/dev/null 2>&1; then
  jq -n --arg out "$OUT" --arg slug "$SLUG" '{out_dir: $out, slug: $slug, next: "fill 00-scope.md then doctor.sh and triage-client.sh"}'
else
  echo "{\"out_dir\":\"$OUT\",\"slug\":\"$SLUG\"}"
fi
