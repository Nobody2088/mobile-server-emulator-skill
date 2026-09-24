# Playbook 03 · Protocol

Goal: turn bytes into reproducible message notes. Read [protobuf-workflow.md](../references/protobuf-workflow.md), [wire-protocol.md](../references/wire-protocol.md), [login-sequence.md](../references/login-sequence.md).

## Steps

1. `bash scripts/capture-traffic.sh --help` — HTTP via mitmproxy; raw TCP via hex logs or pcap in `capture/samples/`.
2. `bash scripts/proto-extract.sh --jadx-dir cases/<slug>/client/jadx_out --apktool-dir cases/<slug>/client/apktool_out --out cases/<slug>/protocol/static`
3. Copy [PACKET.md](../templates/protocol/PACKET.md) → `protocol/PKT-###.md` per message.
4. For framing: record total length + first 16 bytes before guessing header size.
5. Still encrypted: mark “undecoded” in PKT; do not invent `.proto`.

## Exit

≥1 login-related PKT with encoding type chosen. Undecoded → listener/logging only until stage 2 clears.
