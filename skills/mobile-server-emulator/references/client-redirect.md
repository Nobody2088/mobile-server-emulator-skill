# Stage 1 · Client redirect

Follow [playbooks/02-redirect.md](../playbooks/02-redirect.md). Exit: [phase-gates.md](phase-gates.md). Failures: `F-REDIRECT-*`.

Goal: every server the client calls — gateway, update, CDN, login, zone list, game, announcement, remote config — connects to your LAN IP or your domain. Login-only is not done.

## Decision tree

```
Can change DNS / hosts / adb reverse?
├─ yes → prefer DNS or reverse (hostname stays, address changes)
└─ no → repack string replace, then Frida connect hook

Engine?
├─ weak online (JSON/XML in assets) → edit assets/res
├─ Unity IL2CPP → string patch or DNS — unity-il2cpp.md
├─ Cocos / Lua → assets or .so strings
└─ native Java → smali or SharedPreferences
```

## Endpoint inventory

Run after unpack:

```bash
bash scripts/catalog-endpoints.sh \
  --dir cases/<slug>/client/apktool_out \
  --out cases/<slug>/docs/endpoints.md
```

The script scans `http`, `https`, `ws`, `wss`, and `host:port`. It does not patch. Copy or symlink that file to `client/endpoints.md`.

Roles to fill, one row each:

| Role | Examples |
|------|----------|
| update | version check, hotfix manifest |
| cdn | AssetBundles, Addressables, Octo list |
| gateway | returns game host and port |
| login | account / token |
| zone | server list, realm |
| game | world, battle TCP or WebSocket |
| notice | announcement, marquee |
| config | remote config, feature flags |

Columns: role, scheme, host, port, protocol (HTTP, TCP, WebSocket, gRPC), official value, replacement, evidence.

## Replacement target

`--new` accepts:

- IPv4: `192.168.1.10`
- IPv6: `[fd00::10]` (bracket the host in URLs)
- Domain: `game.lan` or a public name you control

### DNS / hosts (hostname stays)

Use when the client stores a hostname and you can change resolution.

- Router DNS or dnsmasq: `address=/api.game.com/192.168.1.10`
- Hosts file on a rooted device or emulator: `192.168.1.10 api.game.com`
- `adb reverse tcp:8080 tcp:8080` only for ports on the same machine. It does not rewrite a remote IP baked into the binary.

Record the DNS name and the port the client hardcodes. Some clients keep gRPC on 443 and HTTP on another port. Do not collapse those into one listener.

### String replace (hostname or URL changes)

Use `patch-endpoint.sh --mode assets` for JSON, XML, Lua, and txt under `assets/` and `res/`.

For `libil2cpp.so`, `global-metadata.dat`, or other binaries:

- The replacement must be the same length or shorter, padded with nulls or spaces the client already tolerates.
- Longer strings overflow the slot and crash the loader.
- Prefer DNS when the official hostname can stay.

### Domain mode

Point the client at a name (`game.lan` or a real domain):

1. Client strings or DNS use that name, not a raw IP, when the protocol sends the host in SNI or Host headers.
2. DNS for that name resolves to the LAN IP (or the public IP of the tunnel).
3. Document each hardcoded port next to the name in `endpoints.md`.
4. Cleartext HTTP needs a network security config that allows the domain. HTTPS needs a cert for that name, or a pin bypass you already recorded in the failure catalog.

### Frida

`templates/frida/connect-redirect.js` hooks `connect()`. Use it when DNS and string replace both miss a native IP. It is a fallback, not the steady redirect.

## Weak-online games

1. `apktool d game.apk -o apktool_out`
2. `catalog-endpoints.sh` then `grep` for leftovers
3. Edit `serverUrl`, gateway, and update URLs together
4. Repack and sign — `patch-endpoint.sh`

## Evidence

- `docs/endpoints.md` with official and replacement for gateway and update at minimum
- File diffs or DNS config
- Logcat or proxy showing those hosts on your IP or domain, not only the login URL
