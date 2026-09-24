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
2. Run Il2CppDumper → `dump.cs`, `script.json`, `stringliteral.json`, DummyDll. Save under `client/il2cpp/`
3. Search `http`, `api`, `socket`, `port`, gateway, update, CDN
4. Addressables / asset catalog (`catalog.json`, `catalog.bin`) lists scene and table slugs. Record them in `docs/index.md`
5. If `global-metadata.dat` is encrypted or Il2CppDumper throws, dump the raw metadata after the runtime decrypts it (`MetadataCache.Initialize`), then re-run Il2CppDumper. A static failure is not an empty catalog
6. JS/Puerts gameplay that is missing from `dump.cs` is loaded as script files. Note those paths in `docs/index.md`
7. Redirect: DNS or domain first; same-length or shorter string patch in `.so` or metadata if the host slot is fixed
8. Core logic in native → Frida JNI hooks

## Class name hints

`NetworkManager`, `HttpClient`, `SocketClient`, `LoginManager`, `Google.Protobuf`, `BestHTTP`

## Split with apk-reverse

- unpack / resign → `apk-reverse` scripts
- IL2CPP symbols → this file + `rev-u3d-dump`
