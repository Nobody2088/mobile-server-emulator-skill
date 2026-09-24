# Unity IL2CPP 客户端分析

## 识别

- APK 含 `lib/*/libil2cpp.so`
- 含 `assets/bin/Data/Managed/Metadata/global-metadata.dat`
- triage 脚本输出 `"engine": "unity-il2cpp"`

## 工具链

| 工具 | 用途 |
|------|------|
| Il2CppDumper | 从 so + metadata 导出 DummyDll、script.json、stringliteral |
| IDA / Ghidra | 字符串搜索、patch 域名 |
| `rev-u3d-dump` skill | Agent 侧符号恢复指引 |

## 工作流

1. 解包 APK，定位 `libil2cpp.so` 与 `global-metadata.dat`
2. 运行 Il2CppDumper，得到 `stringliteral.json` 与 `dump.cs`
3. 在 stringliteral / dump.cs 中搜索 `http`、`api`、`socket`、`port`
4. **Patch 策略**（授权范围内）：
   - 同长度或更短字符串覆盖官方域名（hex 编辑器 / IDA patch）
   - 或改用 DNS 劫持，避免改 so
5. 若核心逻辑在 native，结合 Frida hook JNI 导出

## 常见类名关键词

```
NetworkManager, HttpClient, SocketClient, LoginManager,
GameServer, ProtoBuf, Google.Protobuf, BestHTTP
```

## 与 apk-reverse 分工

- 解包 / 重签 → `apk-reverse` 的 `decode.sh` / `rebuild-sign-install.sh`
- 符号与 IL2CPP → 本文件 + `rev-u3d-dump`
