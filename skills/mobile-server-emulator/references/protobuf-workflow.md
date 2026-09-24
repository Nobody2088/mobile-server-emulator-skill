# Protobuf 协议还原

配合 [playbooks/03-protocol.md](../playbooks/03-protocol.md) 与 [templates/protocol/PACKET.md](../templates/protocol/PACKET.md)。字段号只来自样本或反编译，不来自猜测。

现代手游常见 Google Protobuf 或同类二进制序列化。

## 静态提取

1. **Java/Kotlin**：jadx 搜索 `extends GeneratedMessageLite`、`parseFrom`、`toByteArray`
2. **IL2CPP**：Il2CppDumper 的 `dump.cs` 搜索 `Google.Protobuf`
3. **已有 .proto**：部分游戏在 assets 留 `*.protogen` 或 `descriptor`

## 动态提取

1. Frida hook `MessageLite.parseFrom` / `toByteArray`（见 `templates/frida/protobuf-log.js`）
2. mitmproxy 若已是明文 JSON，直接记录；若是 binary body，保存 hex 样本

## 还原 .proto 步骤

1. 收集多条同类型消息的 hex
2. 使用 [protobuf-inspector](https://github.com/mildsunrise/protobuf-inspector) 或 `protoc --decode_raw`
3. 推断 field number 与 wire type
4. 手写 `.proto`，用 Python `google.protobuf` 或 Node `protobufjs` 验证编解码

## 脚本

```bash
bash scripts/proto-extract.sh --jadx-dir ./jadx_out --out ./proto_work
```

## 服务端使用

- Python：`pip install protobuf` + `message.ParseFromString(body)`
- Node：`protobufjs` 加载 `.proto`
- Go：`protoc --go_out`（适合高性能 emulator）

## 输出证据

- 至少一份可编译的 `.proto` 或 field map
- 一条登录请求的 decode 示例（JSON 形式）
