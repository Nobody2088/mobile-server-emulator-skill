# Engine and network fingerprint

`triage-client.sh` is a first pass. Confirm in `client/engine.md`.

## File signatures

| Engine | APK signals | triage `engine` |
|--------|-------------|-----------------|
| Unity IL2CPP | `lib/*/libil2cpp.so`, `global-metadata.dat` | `unity-il2cpp` |
| Unity Mono | `Assembly-CSharp.dll` in assets | note `unity-mono` |
| Cocos | `libcocos2d*.so`, `assets/src` or `.jsc` | `cocos` |
| Native Android | `classes.dex`, no game `.so` | `native-java` |
| Flutter | `libflutter.so`, `libapp.so` | note `flutter` |
| Unreal | `libUE4.so` / `libUnreal.so` | note `unreal` |
| Hotfix scripts | many `.lua` / `.json` in assets | add `+hotfix` |

## Network stack hints

| Hint | Usually means |
|------|----------------|
| okhttp3 / retrofit2 | HTTP(S) + JSON |
| io.grpc | HTTP/2 + Protobuf |
| WebSocket classes | WS binary/JSON |
| Google.Protobuf | Protobuf |
| BestHTTP / UnityWebRequest | Unity HTTP |
| Socket / TcpClient | custom TCP |
| kcp / enet | UDP reliability layer |

## Where hosts hide (search order)

1. `assets/` and `res/values/strings.xml`
2. Java constants: `BASE_URL`, `HOST`
3. Unity stringliteral / metadata
4. Cleartext in `.so` (record offset + string)
5. Runtime-only game server after login API

## Version lock

Record versionName, versionCode, ABI, hotfix version if any. Protocol notes bind to this triple.
