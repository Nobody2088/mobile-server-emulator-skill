# Playbook 03 · 协议还原

目标：把已经打到你这边的字节，变成可复现的消息笔记。不猜未出现的字段。

读 [protobuf-workflow.md](../references/protobuf-workflow.md) 与 [wire-protocol.md](../references/wire-protocol.md)。登录顺序用 [login-sequence.md](../references/login-sequence.md) 对表。

## 步骤

1. 环境：

```bash
bash scripts/capture-traffic.sh --help
```

HTTP 走 mitmproxy。纯 TCP 用服务端十六进制日志或抓包，把样本放 `capture/samples/`，文件名 `PKT-###.hex`。

2. 静态线索：

```bash
bash scripts/proto-extract.sh \
  --jadx-dir cases/<slug>/client/jadx_out \
  --apktool-dir cases/<slug>/client/apktool_out \
  --out cases/<slug>/protocol/static
```

3. 每识别一条消息，复制 [PACKET.md](../templates/protocol/PACKET.md) 为 `protocol/PKT-###.md` 并填六项（见 login-sequence）。
4. 帧头：先记录总长度和前 16 字节。只有 `--decode_raw` 在去掉固定头之后成功，才把头长写死。
5. 仍是密文：在 PKT 里写「未解码」、长度、以及静态分析里最接近的加密类名。停止编造 `.proto`。

## 退出

至少一条与登录相关的 PKT，且编码类型已选：JSON、Protobuf、自定义帧、未解码。未解码不能进入「假装 JSON」的服务端实现，只能做记录型监听。
