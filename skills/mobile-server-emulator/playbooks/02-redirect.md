# Playbook 02 · Redirect

Goal: game traffic hits your machine. Read [client-redirect.md](../references/client-redirect.md). Unity: [unity-il2cpp.md](../references/unity-il2cpp.md). Exit: [phase-gates.md](../references/phase-gates.md). Failures: `F-REDIRECT-*`.

## Pick one path first

1. **Emulator on same PC:** `adb reverse tcp:<port> tcp:<port>`
2. **LAN DNS / hosts:** official hostname → your PC IP
3. **Edit assets/res** when full URLs live in JSON/XML
4. **Native strings / runtime connect:** document offsets in `redirect-notes.md`; try 1–2 before binary patches

## Commands

```bash
bash scripts/decode-client.sh cases/<slug>/client/apk/game.apk --out cases/<slug>/client
bash scripts/patch-endpoint.sh --mode report --dir cases/<slug>/client/apktool_out
bash scripts/patch-endpoint.sh --mode dns --old https://game.example --new 192.168.1.10
```

## Host table

Fill `client/redirect-notes.md` for login server, game server, CDN.

## Exit

Runtime log shows **your** host. “Files edited” alone is not enough.
