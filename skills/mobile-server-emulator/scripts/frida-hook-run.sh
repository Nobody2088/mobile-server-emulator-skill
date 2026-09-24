#!/usr/bin/env bash
# frida-hook-run.sh — Frida 注入封装（spawn / attach）
# 用法: bash frida-hook-run.sh --package PKG --script PATH [--spawn] [--device SERIAL]

set -euo pipefail

PACKAGE=""
SCRIPT=""
SPAWN=false
DEVICE=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --package) PACKAGE="$2"; shift 2 ;;
    --script) SCRIPT="$2"; shift 2 ;;
    --spawn) SPAWN=true; shift ;;
    --device) DEVICE="$2"; shift 2 ;;
    --list-devices)
      frida-ls-devices 2>/dev/null || frida-ps -U 2>&1 || echo "Install: pip install frida-tools" >&2
      exit 0
      ;;
    --help)
      echo "Usage: frida-hook-run.sh --package com.app --script hook.js [--spawn]"
      exit 0
      ;;
    *) echo "Unknown: $1" >&2; exit 1 ;;
  esac
done

if ! command -v frida >/dev/null 2>&1; then
  echo "Missing frida. Bootstrap: pip install frida-tools" >&2
  exit 1
fi

if [[ -z "$PACKAGE" ]] || [[ -z "$SCRIPT" ]] || [[ ! -f "$SCRIPT" ]]; then
  echo "Need --package and existing --script" >&2
  exit 1
fi

FRIDA=(frida)
[[ -n "$DEVICE" ]] && FRIDA=(frida -D "$DEVICE")
FRIDA+=(-U)

if [[ "$SPAWN" == "true" ]]; then
  exec "${FRIDA[@]}" -f "$PACKAGE" -l "$SCRIPT" --no-pause 2>/dev/null || exec "${FRIDA[@]}" -f "$PACKAGE" -l "$SCRIPT"
else
  exec "${FRIDA[@]}" -n "$PACKAGE" -l "$SCRIPT"
fi
