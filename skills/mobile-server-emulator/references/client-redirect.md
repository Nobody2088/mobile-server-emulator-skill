# Stage 1 · Client redirect

Follow [playbooks/02-redirect.md](../playbooks/02-redirect.md). Exit: [phase-gates.md](phase-gates.md). Failures: `F-REDIRECT-*`.

Goal: client connects to your local or tunneled server.

## Decision tree

```
Can change DNS / adb reverse?
├─ yes → prefer DNS or reverse (no repack)
└─ no → repack or Frida connect hook

Engine?
├─ weak online (JSON/XML in assets) → edit assets/res
├─ Unity IL2CPP → string patch or DNS — unity-il2cpp.md
├─ Cocos / Lua → assets or .so strings
└─ native Java → smali or SharedPreferences
```

## Weak-online games

1. `apktool d game.apk -o apktool_out`
2. `grep -r "http" apktool_out/assets apktool_out/res`
3. Edit `serverUrl`, `api_host`, etc.
4. Repack and sign — `patch-endpoint.sh`

## DNS / hosts (no repack)

- Router DNS or dnsmasq: `address=/api.game.com/192.168.x.x`
- `adb reverse tcp:8080 tcp:8080` for local dev

## Frida redirect

Use `templates/frida/connect-redirect.js` to hook `connect()`.

## Evidence

- File diffs or DNS config
- Logcat/proxy showing connections to your host
