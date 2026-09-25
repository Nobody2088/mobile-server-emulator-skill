# Stage 4 · Tunnel and multiplayer

Follow [playbooks/05-tunnel.md](../playbooks/05-tunnel.md). Local login first, then public exposure. Failures: `F-TUNNEL-*`.

## Local dev

```bash
adb reverse tcp:8080 tcp:8080
adb reverse tcp:9000 tcp:9000
adb reverse --list
```

MuMu-style emulators: `adb connect 127.0.0.1:7555`

## LAN DNS

dnsmasq: `address=/game-api.example.com/192.168.1.100`

## Internet tunnel

| Tool | Notes |
|------|-------|
| frp | self-hosted VPS, multi-port |
| ngrok | quick, limited free tier |
| nps | web UI |

```bash
bash scripts/tunnel-setup.sh --tool frp --local-port 8080 --remote-port 8080 --out ./tunnel
```

Template: `templates/config/frpc.example.toml`

## Multiplayer

- Single DB on stub server — tunnel stays stateless
- Friends use same public host in client or shared VPN
- Map HTTP + game TCP ports separately in frp

## Ops

- Use frp token / TLS on public endpoints
- Bind admin/debug to localhost; expose only game HTTP/TCP ports through the tunnel
- Keep tokens and pcaps under `cases/<slug>/`, not in the skill repo
