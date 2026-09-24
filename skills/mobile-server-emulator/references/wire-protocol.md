# 自定义线协议（TCP / WebSocket / 帧头）

Protobuf 之上常还有自定义 framing 或加密层。

## 常见帧格式

| 模式 | 特征 | 处理 |
|------|------|------|
| 长度前缀 | 前 2/4 字节为 body 长度（大/小端） | 先读 header 再读 body |
| Magic | 固定魔数如 `0xDEADBEEF` | 校验后解析 |
| 序号 + CRC | header 含 seq、crc32 | 对照开源项目或 Frida 日志 |
| TLS 外层 | 443 端口 | mitmproxy + unpin |
| WebSocket | `ws://` 或 Upgrade | 抓 WS 帧内 binary |

## 分析步骤

1. Wireshark / mitmproxy 保存 pcap
2. 对比多条消息找固定 header 长度
3. Frida hook `InputStream.read` / `send` / `recv` 打印 hex
4. 对照 GitHub preservation 项目的 packet 定义

## 服务端实现模板

```python
async def read_packet(reader):
    header = await reader.readexactly(4)
    length = int.from_bytes(header, "big")
    body = await reader.readexactly(length)
    return body
```

## 加密层

若 body 仍不可读：

- 搜索 APK 内 `AES`、`Cipher`、`xxtea`、`xor`
- Frida hook 加密函数 **入参/出参**（加密前往往是 protobuf 明文）
- 转交 `protocol-cryptanalysis` skill 做深度分析
