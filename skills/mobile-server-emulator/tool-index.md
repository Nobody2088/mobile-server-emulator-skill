# Tool index and bootstrap

Probe tools before running playbooks. Install from the Bootstrap column — do not guess paths.

## Core tools

| Tool | Use | Check | Bootstrap (macOS) |
|------|-----|-------|-------------------|
| adb | device / reverse | `adb version` | `brew install android-platform-tools` |
| jadx | Java decompile | `jadx --version` | `brew install jadx` |
| apktool | unpack / repack | `apktool --version` | `brew install apktool` |
| frida | dynamic hook | `frida-ps --version` | `pip install frida-tools` |
| mitmproxy | HTTPS capture | `mitmproxy --version` | `brew install mitmproxy` |
| Il2CppDumper | Unity symbols | binary on PATH | GitHub release |
| zipalign | APK align | `zipalign` | Android SDK build-tools |
| apksigner | APK sign | `apksigner` | Android SDK build-tools |

## Optional

| Tool | Use |
|------|-----|
| protoc | compile protobuf |
| wireshark / tshark | pcap |
| frpc / ngrok | tunnel |
| radare2 / ghidra | native |

## Environment

| Variable | Purpose |
|----------|---------|
| `ANDROID_HOME` | SDK incl. platform-tools |
| `JAVA_HOME` | jadx / apktool |

Run `scripts/doctor.sh` first; install only what the current playbook needs.

| Script | Stage |
|--------|-------|
| `doctor.sh` | workspace |
| `init-workspace.sh` | workspace |
| `triage-client.sh` | 0 |
| `catalog-client.sh` / `catalog-endpoints.sh` | 0b |
| `decode-client.sh` / `patch-endpoint.sh` | 1 |
| `capture-traffic.sh` / `proto-extract.sh` / `frida-hook-run.sh` | 2 |
| `server-bootstrap.sh` | 3 |
| `tunnel-setup.sh` | 4 |

## frida-server on device

1. `adb devices`
2. Download matching arch from [Frida releases](https://github.com/frida/frida/releases)
3. `adb push frida-server /data/local/tmp/ && adb shell chmod 755 /data/local/tmp/frida-server`
4. `adb shell /data/local/tmp/frida-server &`
5. `frida-ps -U`
