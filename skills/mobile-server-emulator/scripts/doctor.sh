#!/usr/bin/env bash
# doctor.sh — probe tools used by this skill, emit JSON
# Usage: bash doctor.sh

set -euo pipefail

check() {
  local name="$1"
  local cmd="$2"
  if command -v "$cmd" >/dev/null 2>&1; then
    local ver
    ver=$("$cmd" --version 2>&1 | head -1 || true)
    printf '{"name":"%s","present":true,"version":%s}\n' "$name" "$(printf '%s' "$ver" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read().strip()))')"
  else
    printf '{"name":"%s","present":false,"version":null}\n' "$name"
  fi
}

TOOLS=$(
  check adb adb
  check jadx jadx
  check apktool apktool
  check frida frida
  check mitmproxy mitmproxy
  check aapt aapt
  check jq jq
  check python3 python3
  check node node
)

if command -v jq >/dev/null 2>&1; then
  echo "$TOOLS" | jq -s '{tools: .}'
else
  echo "$TOOLS" | python3 -c 'import json,sys; print(json.dumps({"tools":[json.loads(l) for l in sys.stdin if l.strip()]}))'
fi
