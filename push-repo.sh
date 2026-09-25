#!/usr/bin/env bash
# push-repo.sh — commit (if needed), push to GitHub, sync local skill installs
# Usage: bash push-repo.sh ["commit message"]

set -euo pipefail

ROOT=$(cd "$(dirname "$0")" && pwd)
cd "$ROOT"

MSG=${1:-"update by push"}
SKILL_SRC="$ROOT/skills/mobile-server-emulator"

if ! git diff --quiet || ! git diff --cached --quiet || [[ -n "$(git status --porcelain)" ]]; then
  git add -A
  git commit -m "$MSG"
fi

git push origin HEAD

AGENTS_DIR="${HOME}/.agents/skills/mobile-server-emulator"
ZCODE_DIR="${HOME}/.zcode/skills/mobile-server-emulator"
mkdir -p "$(dirname "$AGENTS_DIR")" "$(dirname "$ZCODE_DIR")"
rsync -a --delete "$SKILL_SRC/" "$AGENTS_DIR/"
rsync -a --delete "$SKILL_SRC/" "$ZCODE_DIR/"

echo "Pushed $(git rev-parse --short HEAD) and synced to:"
echo "  $AGENTS_DIR"
echo "  $ZCODE_DIR"
