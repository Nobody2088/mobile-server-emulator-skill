# Playbook 02 · Redirect

Goal: gateway, update, and the other inventoried hosts hit your LAN IP or domain. Read [client-redirect.md](../references/client-redirect.md). Unity: [unity-il2cpp.md](../references/unity-il2cpp.md). Exit: [phase-gates.md](../references/phase-gates.md). Failures: `F-REDIRECT-*`.

Enter only after [01-unpack.md](01-unpack.md). `docs/endpoints.md` must exist.

## Pick one path first

1. **Emulator on same PC:** `adb reverse tcp:<port> tcp:<port>` for each hardcoded local port
2. **LAN DNS / hosts:** official hostname → your PC IP, or your domain → that IP
3. **Edit assets/res** when full URLs live in JSON/XML
4. **Native strings / runtime connect:** same-length replace; document offsets in `redirect-notes.md`. Try 1–2 before binary patches

## Commands

```bash
bash scripts/catalog-endpoints.sh \
  --dir cases/<slug>/client/apktool_out \
  --out cases/<slug>/docs/endpoints.md

bash scripts/patch-endpoint.sh --mode report --dir cases/<slug>/client/apktool_out

# LAN IP
bash scripts/patch-endpoint.sh --mode dns --old https://gw.example.com --new 192.168.1.10

# Domain (DNS still points the name at your machine)
bash scripts/patch-endpoint.sh --mode dns --old https://gw.example.com --new game.lan

bash scripts/patch-endpoint.sh \
  --mode assets \
  --dir cases/<slug>/client/apktool_out \
  --old https://update.example.com \
  --new http://192.168.1.10:8080
```

Repeat assets/dns for update, CDN, gateway, login, and zone hosts. One login URL is not the exit.

## Host table

Fill `client/redirect-notes.md` and `docs/endpoints.md` for:

- update
- cdn
- gateway
- login
- zone
- game
- notice
- config

Mark the target as an IPv4, IPv6, or domain. Note any port the client hardcodes (for example gRPC 443 plus a separate HTTP port).

## Length check

Before patching `libil2cpp.so` or `global-metadata.dat`, compare string lengths. If the new host is longer, switch to DNS or a shorter name. Do not write past the original slot.

## Exit

Runtime log shows **your** IP or domain for gateway and update, not only login. “Files edited” alone is not enough.
