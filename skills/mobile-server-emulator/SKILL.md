---
name: mobile-server-emulator
description: >
  手游服务端模拟器开发（Server Emulator Development）通用工作流。
  适用于已停服/授权范围内的 Android 手游：客户端地址重定向、抓包与 Protobuf
  协议还原、最小伪服务端搭建、内网穿透联机。触发词：私服、server emulator、
  private server、协议还原、IL2CPP、伪服务端、停服游戏 preservation。
---

## ACTION REQUIRED（读完后立刻执行）

> 合规边界见 `references/legal-scope.md`；工具见 `tool-index.md`；路由见 `routing.md`。

1. `NOW`: 读取 `references/legal-scope.md` — 确认任务在允许范围，否则拒绝
2. `NOW`: 读取 `tool-index.md` — 探测 jadx / apktool / frida / adb / mitmproxy
3. `NEXT`: 若有 APK，运行 `scripts/triage-client.sh <apk>` — 获取 engine / network_hints
4. `NEXT`: 按 `routing.md` 进入对应四阶段路径
5. `ACT`: 从阶段 1 或 triage 推荐的阶段开始执行，**不要**跳过 triage 直接改包

---

# 手游服务端模拟器 — CLI 作业规范

## 0. 合规边界（最高优先级）

- **允许**：已停服 preservation、自有 App/靶场、书面授权研究、学习公开 GitHub emulator 架构。
- **禁止**：仍在运营商业手游未授权私服、伪造充值、破坏他人体验、分发改包牟利。
- 详见 [legal-scope.md](references/legal-scope.md)。

## 适用范围

- 客户端改址 / DNS / adb reverse / IL2CPP 字符串 patch
- HTTPS / TCP / WebSocket / Protobuf 协议还原
- 最小伪服务端（登录 → 角色 → 进场）
- frp / ngrok / adb reverse 联机
- 检索 GitHub 现有 server emulator 项目

## 四阶段工作流

```
Triage → ① 地址重定向 → ② 抓包协议 → ③ 伪服务端 → ④ 穿透联机
```

### 阶段 0：Triage

```bash
bash scripts/triage-client.sh /path/to/game.apk
```

输出 JSON：`package`、`engine`、`has_il2cpp`、`network_hints`、`config_urls`、`recommended_path`。

然后读 [routing.md](routing.md) 选路径。

### 阶段 1：客户端地址重定向

详见 [client-redirect.md](references/client-redirect.md)。

| 场景 | 做法 | 脚本 |
|------|------|------|
| 弱联网 JSON/XML | 改 assets/res | `patch-endpoint.sh --mode assets` |
| Unity IL2CPP | DNS 或 so 字符串 | [unity-il2cpp.md](references/unity-il2cpp.md) |
| 免改包 | DNS / hosts / adb reverse | `patch-endpoint.sh --mode dns` |
| 运行时改连 | Frida connect hook | `frida-hook-run.sh` |

解包优先：

```bash
bash scripts/decode-client.sh /path/to/game.apk
```

### 阶段 2：抓包与协议还原

详见 [protobuf-workflow.md](references/protobuf-workflow.md)、[wire-protocol.md](references/wire-protocol.md)。

```bash
bash scripts/capture-traffic.sh --help          # mitmproxy + adb cert 指引
bash scripts/proto-extract.sh --jadx-dir ./jadx_out --out ./proto_work
bash scripts/frida-hook-run.sh --package com.example.game --script templates/frida/protobuf-log.js
```

要点：

- HTTPS：mitmproxy 证书 + `templates/frida/ssl-unpin.js`
- Protobuf：静态 jadx/Il2CppDumper + 动态 hook `parseFrom`
- 自定义帧：pcap + Frida hex log → [wire-protocol.md](references/wire-protocol.md)

### 阶段 3：最小伪服务端

详见 [fake-server-patterns.md](references/fake-server-patterns.md)、[open-source-catalog.md](references/open-source-catalog.md)。

**先搜 GitHub**：`"<游戏名>" server emulator`

无现成项目时：

```bash
bash scripts/server-bootstrap.sh --slug mygame --lang python --out ./mygame_server
# 或 --lang node
```

闭环顺序：**登录 success → 角色列表 → 进场 state → 补 crash 触发的 API**。

### 阶段 4：穿透与联机

详见 [tunnel-multiplayer.md](references/tunnel-multiplayer.md)。

```bash
adb reverse tcp:8080 tcp:8080
bash scripts/tunnel-setup.sh --tool frp --local-port 8080 --remote-port 8080 --out ./tunnel
```

## 优先使用脚本的场景

| 脚本 | 用途 |
|------|------|
| `triage-client.sh` | APK 指纹与路由建议 |
| `decode-client.sh` | jadx + apktool 落盘 |
| `capture-traffic.sh` | 抓包环境检查与指引 |
| `proto-extract.sh` | Protobuf 线索扫描 |
| `patch-endpoint.sh` | 改址决策与 grep 报告 |
| `server-bootstrap.sh` | 生成 Python/Node 服务端骨架 |
| `tunnel-setup.sh` | frp/ngrok 配置生成 |
| `frida-hook-run.sh` | Frida 注入封装 |

单行命令保持直接调用：`adb devices`、`frida-ps -U`、`jadx --version`。

## 输出要求

最终至少说明：

- triage 结果与选用路径
- 官方地址 → 本地地址的改法（或 DNS 方案）
- 协议格式（HTTP/JSON、Protobuf field map、帧头长度）
- 已实现 handler 列表与登录是否闭环
- 穿透方式与端口映射
- 合规声明（目标是否在允许范围）

## 禁止事项

- 不要跳过 legal-scope 与 triage
- 不要对仍在运营游戏提供完整私服搭建步骤
- 不要假设所有游戏共用同一协议
- 不要在 Java 层无果时忽略 IL2CPP / native
- 不要用超时掩盖「客户端仍连官方」的问题 — 回到阶段 1

## 路由上下文

**上游**：用户 preservation / 授权研究任务  
**下游**：

| 片段 | 转交 |
|------|------|
| 纯 APK smali/重签 | `apk-reverse` |
| IL2CPP 符号 | `rev-u3d-dump` |
| Frida 复杂脚本 | `rev-frida` |
| 加密协议 | `protocol-cryptanalysis` |
| UI 测试 | `game-automation-scripting` |

详见 [community-skills.md](references/community-skills.md)。

## 任务完成自检

- [ ] 已读 legal-scope 且任务在允许范围
- [ ] 已运行 triage（或有 APK 时补跑）
- [ ] 阶段 1 证据：客户端指向本地/穿透地址
- [ ] 阶段 2 证据：至少一条请求/响应结构
- [ ] 阶段 3 证据：登录接口返回 success（log 或截图）
- [ ] 若需联机：阶段 4 端口映射已文档化
- [ ] 未将密钥、抓包样本、用户数据写入仓库
