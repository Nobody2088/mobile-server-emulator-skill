#!/usr/bin/env bash
# capture-traffic.sh — 抓包环境检查与操作指引
# 用法: bash capture-traffic.sh [--install-cert] [--device serial]

set -euo pipefail

INSTALL_CERT=false
DEVICE=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --install-cert) INSTALL_CERT=true; shift ;;
    --device) DEVICE="$2"; shift 2 ;;
    --help)
      cat <<'EOF'
capture-traffic.sh — 检查 mitmproxy/adb，输出抓包步骤

Steps:
  1. mitmproxy -p 8080  (or mitmweb)
  2. Configure phone WiFi proxy -> PC IP:8080
  3. Open http://mitm.it on phone -> install Android cert
  4. For SSL pinning: use templates/frida/ssl-unpin.js

Options:
  --install-cert   Push mitmproxy cert hint (manual install still required)
  --device SERIAL  adb -s SERIAL
EOF
      exit 0
      ;;
    *) echo "Unknown: $1" >&2; exit 1 ;;
  esac
done

ADB=(adb)
[[ -n "$DEVICE" ]] && ADB=(adb -s "$DEVICE")

MISSING=()
command -v mitmproxy >/dev/null 2>&1 || MISSING+=("mitmproxy")
command -v "${ADB[0]}" >/dev/null 2>&1 || MISSING+=("adb")

if [[ ${#MISSING[@]} -gt 0 ]]; then
  echo "Missing tools: ${MISSING[*]}" >&2
  echo "Bootstrap: brew install mitmproxy android-platform-tools" >&2
  exit 1
fi

"${ADB[@]}" devices >&2

CERT="$HOME/.mitmproxy/mitmproxy-ca-cert.cer"
if [[ "$INSTALL_CERT" == "true" && -f "$CERT" ]]; then
  echo "Cert at $CERT — install via Settings -> Security -> Install from storage" >&2
  "${ADB[@]}" push "$CERT" /sdcard/Download/mitmproxy-ca-cert.cer >&2 || true
fi

PC_IP=$(ipconfig getifaddr en0 2>/dev/null || hostname -I 2>/dev/null | awk '{print $1}' || echo "YOUR_PC_IP")

if command -v jq >/dev/null 2>&1; then
  jq -n \
    --arg proxy_host "$PC_IP" \
    --arg proxy_port "8080" \
    --arg cert "$CERT" \
    '{
      status: "ready",
      proxy: ($proxy_host + ":" + $proxy_port),
      mitm_cert: $cert,
      steps: [
        "Start: mitmproxy -p 8080",
        ("Set phone WiFi proxy to " + $proxy_host + ":8080"),
        "Visit http://mitm.it and install cert",
        "If pinning: frida-hook-run.sh with templates/frida/ssl-unpin.js"
      ]
    }'
else
  echo "{\"status\":\"ready\",\"proxy\":\"$PC_IP:8080\"}"
fi
