# Unity IL2CPP client analysis

## Detection

- `lib/*/libil2cpp.so`
- `assets/bin/Data/Managed/Metadata/global-metadata.dat`
- triage: `"engine": "unity-il2cpp"`

## Toolchain

| Tool | Role |
|------|------|
| Il2CppDumper | DummyDll, script.json, stringliteral |
| IDA / Ghidra | string search, patch |
| `rev-u3d-dump` skill | agent-side symbol recovery |

## Workflow

1. Unpack APK; locate `libil2cpp.so` + metadata
2. Run Il2CppDumper → `stringliteral.json`, `dump.cs`
3. Search `http`, `api`, `socket`, `port`
4. Redirect: DNS/adb reverse first; same-length or shorter string patch in `.so` if needed
5. Core logic in native → Frida JNI hooks

## Class name hints

`NetworkManager`, `HttpClient`, `SocketClient`, `LoginManager`, `Google.Protobuf`, `BestHTTP`

## Split with apk-reverse

- unpack / resign → `apk-reverse` scripts
- IL2CPP symbols → this file + `rev-u3d-dump`
