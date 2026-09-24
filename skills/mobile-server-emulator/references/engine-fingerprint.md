# 引擎与网络栈指纹

`triage-client.sh` 只给初判。本文件用来人工复核，并把结论写进 `01-triage.json` 旁边的 `client/engine.md`。

## 1. 文件特征

| 引擎 | APK 内可见文件 | triage `engine` |
|------|----------------|-----------------|
| Unity IL2CPP | `lib/*/libil2cpp.so`，`assets/bin/Data/Managed/Metadata/global-metadata.dat` | `unity-il2cpp` |
| Unity Mono | `assets/bin/Data/Managed/Assembly-CSharp.dll` | 记为 `unity-mono`（脚本可能标成 unknown，以本表为准） |
| Cocos2d-x / Cocos Creator | `libcocos2d*.so`，`assets/src` 或 `*.jsc` | `cocos` |
| 原生 Android | `classes.dex`，无上述 so | `native-java` |
| Flutter | `libflutter.so`，`libapp.so` | 在笔记里写 `flutter` |
| Unreal | `libUE4.so` 或 `libUnreal.so` | 在笔记里写 `unreal` |
| 热更脚本 | `assets` 里大量 `.lua` / `.json` / `.ab` | 在引擎后加 `+hotfix` |

一个包可以同时有 Java 壳和 IL2CPP 游戏逻辑。以**真正发游戏包**的那层为准，壳只负责更新和登录页。

## 2. 网络栈线索

在 jadx 或字符串里搜这些词，命中的写入 `network_hints`，并注明文件：

| 线索 | 通常意味着 |
|------|------------|
| `okhttp3` / `retrofit2` | HTTP(S) + 多半 JSON |
| `io.grpc` | HTTP/2 + Protobuf |
| `org.java_websocket` / `okhttp3.WebSocket` | WebSocket |
| `Google.Protobuf` / `GeneratedMessageLite` | Protobuf |
| `BestHTTP` / `UnityWebRequest` | Unity HTTP |
| `Socket` / `TcpClient` / `System.Net.Sockets` | 自定义 TCP |
| `kcp` / `enet` | UDP 可靠传输，先记协议名再抓包 |

## 3. 配置落点

按这个顺序找官方主机，找到就停，写入 `redirect-notes.md`：

1. `assets/` 与 `res/values/strings.xml` 里的 `http`
2. Java/Kotlin 常量：`BASE_URL`、`HOST`、`SERVER`
3. Unity `stringliteral` / `global-metadata` 里的域名
4. so 里的明文字符串（只记录偏移与字符串，改不改由阶段 1 决策）
5. 运行时下发：本地没有写死域名，登录后才给游戏服地址。这时阶段 1 只能先打中登录服。

## 4. 推荐路径

| 复核结果 | `recommended_path` | 下一份文档 |
|----------|--------------------|------------|
| IL2CPP 且域名是明文 | `il2cpp_dns_first` | `unity-il2cpp.md`，优先 DNS 或 adb reverse |
| 资源里有完整 URL | `assets_config_first` | `client-redirect.md` 弱联网节 |
| 只有 Retrofit 接口 | `smali_http_first` | `apk-reverse` 解包 + 本技能阶段 2 |
| 运行时才下发地址 | `capture_first` | `playbooks/03-protocol.md` |
| GitHub 已有同版本 emulator | `fork_existing` | `open-source-catalog.md` |

## 5. 版本锁定

记录：

- `versionName` / `versionCode`（`aapt dump badging` 或 manifest）
- ABI：`arm64-v8a` 优先
- 热更资源版本（若启动时下载）

协议笔记全部绑定这个三元组。换版本就新建 `protocol/v<version>/`，不要混用。
