# Protobuf recovery

Use with [playbooks/03-protocol.md](../playbooks/03-protocol.md) and [PACKET.md](../templates/protocol/PACKET.md). Field numbers come from samples or decompile — never from guesses.

## Static

1. jadx: `GeneratedMessageLite`, `parseFrom`, `toByteArray`
2. IL2CPP: Il2CppDumper `dump.cs` for `Google.Protobuf`
3. Rare: `.proto` / `.protogen` in assets

## Dynamic

1. Frida hook `parseFrom` / `toByteArray` — `templates/frida/protobuf-log.js`
2. mitmproxy for cleartext JSON; save binary bodies as hex

## Rebuild `.proto`

1. Collect hex samples per message type
2. `protobuf-inspector` or `protoc --decode_raw`
3. Draft `.proto`; verify with Python `google.protobuf` or Node `protobufjs`

## Script

```bash
bash scripts/proto-extract.sh --jadx-dir ./jadx_out --out ./proto_work
```

## Server runtimes

- Python: `pip install protobuf`
- Node: `protobufjs`
- Go: `protoc --go_out` for high-throughput TCP emulators

## Evidence

- Compilable `.proto` or field map
- One decoded login request as JSON
