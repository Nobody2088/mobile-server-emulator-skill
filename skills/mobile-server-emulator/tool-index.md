# 工具索引与 Bootstrap

执行工作流前探测本机工具。缺省时按「Bootstrap」列安装，**不要猜路径**。

## 核心工具

| 工具 | 用途 | 探测命令 | Bootstrap (macOS) |
|------|------|----------|-------------------|
| adb | 设备 / reverse | `adb version` | `brew install android-platform-tools` |
| jadx | Java 反编译 | `jadx --version` | `brew install jadx` |
| apktool | 解包 / 重打包 | `apktool --version` | `brew install apktool` |
| frida-ps | 动态 Hook | `frida-ps --version` | `pip install frida-tools` |
| mitmproxy | HTTPS 抓包 | `mitmproxy --version` | `brew install mitmproxy` |
| Il2CppDumper | Unity 符号 | 存在可执行文件 | GitHub Release 手动下载 |
| zipalign | APK 对齐 | `zipalign` | Android SDK build-tools |
| apksigner | APK 签名 | `apksigner` | Android SDK build-tools |

## 可选工具

| 工具 | 用途 |
|------|------|
| protoc | protobuf 编译 |
| wireshark / tshark | pcap 分析 |
| frpc / ngrok | 内网穿透 |
| radare2 / ghidra | native 分析 |

## 环境变量

| 变量 | 说明 |
|------|------|
| `ANDROID_HOME` | SDK 路径，含 platform-tools |
| `JAVA_HOME` | apktool / jadx 依赖 |

## 脚本内探测

各 `scripts/*.sh` 在缺工具时会 stderr 提示 bootstrap 命令并以非 0 退出。

## frida-server（设备侧）

1. `adb devices` 确认连接
2. 从 [Frida releases](https://github.com/frida/frida/releases) 下载对应 arch 的 frida-server
3. `adb push frida-server /data/local/tmp/ && adb shell chmod 755 /data/local/tmp/frida-server`
4. `adb shell /data/local/tmp/frida-server &`
5. `frida-ps -U` 验证
