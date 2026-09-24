# Custom wire protocol (TCP / WebSocket / framing)

Protobuf is often wrapped or encrypted.

## Common frames

| Pattern | Signal | Handling |
|---------|--------|----------|
| Length prefix | 2/4 byte body length | read header then body |
| Magic | fixed bytes e.g. `0xDEADBEEF` | validate then parse |
| seq + CRC | header fields | match public emulator or Frida logs |
| TLS | port 443 | mitmproxy + unpin |
| WebSocket | Upgrade | capture WS binary payloads |

## Steps

1. Save pcap or server hex logs
2. Compare messages for fixed header size
3. Frida hook `read`/`send`/`recv` for hex dumps
4. Cross-check public emulator packet defs

## Server template

```python
async def read_packet(reader):
    header = await reader.readexactly(4)
    length = int.from_bytes(header, "big")
    return await reader.readexactly(length)
```

## Encryption layer

If body still opaque: search APK for `AES`, `Cipher`, `xxtea`, `xor`; hook pre-encrypt buffers; escalate to `protocol-cryptanalysis` if needed.
