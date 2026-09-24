# 游戏类型路由

根据 `triage-client.sh` 的 JSON 输出选择路径。

## 路由表

| triage 字段 | 推荐路径 | 阶段重点 |
|-------------|----------|----------|
| `engine: unity-il2cpp` | `il2cpp_dns_first` | DNS 或 Il2CppDumper + 字符串；协议常 Protobuf+TCP |
| `engine: cocos` | `assets_config_first` | assets 内 json/lua 改 URL |
| `engine: native-java` | `smali_http_first` | jadx 找 Retrofit/OkHttp；smali patch |
| `engine: unknown` | `capture_first` | 先抓包再决定 |
| `network_hints` 含 websocket | 加读 `wire-protocol.md` WS 节 | |
| `has_il2cpp: true` | 必读 `unity-il2cpp.md` | |
| 已有 GitHub emulator | `fork_existing` | 读 `open-source-catalog.md`，跳过重复逆向 |

## recommended_path 含义

| 值 | 动作 |
|----|------|
| `il2cpp_dns_first` | 先尝试 DNS/adb reverse；失败再 patch so |
| `assets_config_first` | decode → grep assets → patch-endpoint |
| `smali_http_first` | decode → jadx 定位 API → smali 或 DNS |
| `capture_first` | capture-traffic → proto-extract |
| `fork_existing` | clone 开源项目，只做适配 |

## 阶段跳转规则

- **capture 发现明文 HTTP JSON** → 可直接 server-bootstrap（HTTP stub）
- **capture 发现 binary + protobuf** → proto-extract 后再 server
- **login 仍连官方** → 回到阶段 1 patch-endpoint
- **需要朋友联机** → 阶段 4 tunnel-setup

## 与相邻 skill

- 纯 APK 操作 → `apk-reverse`
- IL2CPP 符号密集 → `rev-u3d-dump`
- Frida 复杂 hook → `rev-frida`
