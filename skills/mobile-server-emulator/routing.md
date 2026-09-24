# Engine routing

Use `triage-client.sh` JSON plus [engine-fingerprint.md](references/engine-fingerprint.md). Open one playbook at a time.

## Route table

| triage signal | path | focus |
|---------------|------|-------|
| `engine: unity-il2cpp` | `il2cpp_dns_first` | DNS or Il2CppDumper strings; often Protobuf+TCP |
| `engine: cocos` | `assets_config_first` | assets json/lua URLs |
| `engine: native-java` | `smali_http_first` | Retrofit/OkHttp; smali or DNS |
| `engine: unknown` | `capture_first` | capture before patch |
| `network_hints` has websocket | also read `wire-protocol.md` WS section | |
| `has_il2cpp: true` | read `unity-il2cpp.md` | |
| public GitHub emulator found | `fork_existing` | `open-source-catalog.md` |

## `recommended_path` values

| Value | Action |
|-------|--------|
| `il2cpp_dns_first` | DNS / adb reverse first; then patch `.so` |
| `assets_config_first` | decode → grep assets → patch-endpoint |
| `smali_http_first` | decode → jadx APIs → smali or DNS |
| `capture_first` | capture-traffic → proto-extract |
| `fork_existing` | clone public project, adapt |

## Stage jumps

- Plain HTTP JSON in capture → HTTP stub server OK
- Binary + protobuf → proto-extract before handlers
- Unpack catalog missing → stage 0b before redirect
- Login still hits official, or gateway/update still official → back to stage 1
- Multiplayer → stage 4 tunnel-setup

## Adjacent skills

- APK only → `apk-reverse`
- IL2CPP symbols → `rev-u3d-dump`
- Heavy Frida → `rev-frida`
