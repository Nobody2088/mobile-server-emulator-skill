# Playbook 05 · Tunnel & second device

Goal: after local login works, another network reaches the **same** database. Read [tunnel-multiplayer.md](../references/tunnel-multiplayer.md).

## Steps

1. Document working `adb reverse` or LAN IP from stage 3.
2. `bash scripts/tunnel-setup.sh --tool frp --local-port 8080 --remote-port 8080 --out cases/<slug>/tunnel`
3. Edit VPS address and token locally — do not commit secrets.
4. Point client (and login response next-hop) at public host.
5. Second device login → same SQLite `account` rows.

## Port table

| Use | Local | Remote | Tool | Evidence |
|-----|-------|--------|------|----------|

## Exit

Stage 4 gates. Tunnel up without second-device login is incomplete.
