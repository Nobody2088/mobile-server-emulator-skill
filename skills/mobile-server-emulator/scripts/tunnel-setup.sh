#!/usr/bin/env bash
# tunnel-setup.sh — generate frp / ngrok config snippet
# Usage: bash tunnel-setup.sh --tool frp|ngrok --local-port 8080 [--remote-port 8080] [--out DIR]

set -euo pipefail

TOOL="frp"
LOCAL_PORT="8080"
REMOTE_PORT="8080"
OUT="."

while [[ $# -gt 0 ]]; do
  case "$1" in
    --tool) TOOL="$2"; shift 2 ;;
    --local-port) LOCAL_PORT="$2"; shift 2 ;;
    --remote-port) REMOTE_PORT="$2"; shift 2 ;;
    --out) OUT="$2"; shift 2 ;;
    *) echo "Unknown: $1" >&2; exit 1 ;;
  esac
done

mkdir -p "$OUT"
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
TEMPLATE="$SCRIPT_DIR/../templates/config/frpc.example.toml"

case "$TOOL" in
  frp)
    OUT_FILE="$OUT/frpc.generated.toml"
    sed "s/{{LOCAL_PORT}}/$LOCAL_PORT/g; s/{{REMOTE_PORT}}/$REMOTE_PORT/g" "$TEMPLATE" > "$OUT_FILE"
    ;;
  ngrok)
    OUT_FILE="$OUT/ngrok.generated.yml"
    cat > "$OUT_FILE" <<EOF
# Run: ngrok http $LOCAL_PORT
version: "2"
tunnels:
  game-api:
    proto: http
    addr: $LOCAL_PORT
EOF
    ;;
  *)
    echo "Unknown tool: $TOOL" >&2
    exit 1
    ;;
esac

if command -v jq >/dev/null 2>&1; then
  jq -n --arg tool "$TOOL" --arg file "$OUT_FILE" --arg local "$LOCAL_PORT" --arg remote "$REMOTE_PORT" \
    '{tool: $tool, config_file: $file, local_port: $local, remote_port: $remote}'
else
  echo "{\"tool\":\"$TOOL\",\"config_file\":\"$OUT_FILE\"}"
fi
