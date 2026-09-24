---
name: mobile-server-emulator
description: >
  手游服务端模拟器开发（Server Emulator Development）商业级作业系统。
  覆盖已停服或书面授权范围内的 Android 客户端：立案与阶段门禁、引擎指纹、
  地址重定向、抓包与 Protobuf/自定义帧还原、最小服务端闭环、穿透联机、
  证据账本与失败目录。触发词：私服、server emulator、private server、
  协议还原、IL2CPP、伪服务端、停服 preservation、架设。
---

## ACTION REQUIRED（读完后立刻执行，禁止停在概述）

1. `NOW` 读 [references/legal-scope.md](references/legal-scope.md)。不在允许范围则停止，并按文中话术拒绝。
2. `NOW` 读 [references/engagement-os.md](references/engagement-os.md)。没有案件目录就运行：
   `bash scripts/init-workspace.sh --slug <slug> --out ./cases/<slug>`
3. `NOW` 运行 `bash scripts/doctor.sh`，把 JSON 写入案件目录 `00-doctor.json`。缺工具只补当前阶段需要的，不要一次装完全部。
4. `NEXT` 有 APK 时运行 `bash scripts/triage-client.sh <apk>`，结果写入 `01-triage.json`，再读 [routing.md](routing.md)。
5. `ACT` 只打开**当前阶段**的 playbook，做完该阶段退出条件再进下一阶段。退出条件见 [references/phase-gates.md](references/phase-gates.md)。

禁止：跳过立案直接改包；跳过协议笔记直接堆 handler；把密钥、pcap、APK 写进本技能仓库。

---

# 手游服务端模拟器作业规范

本技能是一套可复用的**案件作业系统**，不是某一款游戏的现成服务端。Agent 的交付物是案件目录里的证据、协议笔记、可启动的最小服务端和阶段报告，不是口头步骤。

## 0. 范围

允许与禁止以 [legal-scope.md](references/legal-scope.md) 为准。仍在运营的商业手游、伪造充值、对官方服作弊、公开售卖改包，全部停止。

## 1. 必读顺序

| 顺序 | 文件 | 何时读 |
|------|------|--------|
| 1 | `references/legal-scope.md` | 每次任务开头 |
| 2 | `references/engagement-os.md` | 建目录、命名证据 |
| 3 | `tool-index.md` + `scripts/doctor.sh` | 工具缺口 |
| 4 | `routing.md` + `references/engine-fingerprint.md` | triage 之后 |
| 5 | 当前阶段 playbook | 只读一个 |
| 6 | `references/failure-catalog.md` | 卡住时，先对症状再改代码 |
| 7 | `templates/report/ENGAGEMENT.md` | 阶段结束时填写 |

Playbook：

- [playbooks/01-triage.md](playbooks/01-triage.md)
- [playbooks/02-redirect.md](playbooks/02-redirect.md)
- [playbooks/03-protocol.md](playbooks/03-protocol.md)
- [playbooks/04-server.md](playbooks/04-server.md)
- [playbooks/05-tunnel.md](playbooks/05-tunnel.md)

专题（按路由按需打开，不要一次全读）：

- 重定向：[client-redirect.md](references/client-redirect.md)
- Unity：[unity-il2cpp.md](references/unity-il2cpp.md)
- Protobuf：[protobuf-workflow.md](references/protobuf-workflow.md)
- 自定义帧：[wire-protocol.md](references/wire-protocol.md)
- 登录时序：[login-sequence.md](references/login-sequence.md)
- Handler 契约：[handler-contract.md](references/handler-contract.md)
- 数据模型：[data-model.md](references/data-model.md)
- 服务端模式：[fake-server-patterns.md](references/fake-server-patterns.md)
- 穿透：[tunnel-multiplayer.md](references/tunnel-multiplayer.md)
- 开源检索：[open-source-catalog.md](references/open-source-catalog.md)
- 相邻技能：[community-skills.md](references/community-skills.md)

## 2. 阶段机

```
立案 → 0 Triage → 1 重定向 → 2 协议 → 3 服务端 → 4 穿透
         ↑____________ 失败目录：客户端仍打官方 / 解析失败 / 登录后崩溃 _______|
```

每一阶段只有一个所有者：案件目录。脚本只产出 JSON 或文件，不替代笔记。

| 阶段 | 入口命令 | 退出证据 | 详细 |
|------|----------|----------|------|
| 0 | `triage-client.sh` | `01-triage.json` + 引擎结论 | playbook 01 |
| 1 | `decode-client.sh` / `patch-endpoint.sh` | 客户端日志出现本地或穿透地址 | playbook 02 |
| 2 | `capture-traffic.sh` / `proto-extract.sh` | 至少 1 条可复现的请求/响应笔记 | playbook 03 |
| 3 | `server-bootstrap.sh` | 登录接口返回约定成功包，角色可读 | playbook 04 |
| 4 | `tunnel-setup.sh` | 端口映射文档 + 第二台设备能连 | playbook 05 |

门禁细节：[phase-gates.md](references/phase-gates.md)。

## 3. 案件目录（必须先建）

```bash
bash scripts/init-workspace.sh --slug mygame --title "Mygame preservation" --out ./cases/mygame
```

生成结构见 [engagement-os.md](references/engagement-os.md)。之后所有 jadx、pcap、proto、server 都放在该目录，不放进技能仓库。

## 4. 工具与脚本

高频且易错的步骤走脚本；一行探测保持原生命令。

| 脚本 | 产出 |
|------|------|
| `doctor.sh` | 工具是否存在的 JSON |
| `init-workspace.sh` | 案件骨架 + 报告草稿 |
| `triage-client.sh` | 引擎 / URL / recommended_path |
| `decode-client.sh` | `jadx_out` + `apktool_out` |
| `patch-endpoint.sh` | URL 命中报告，或 assets/DNS 方案 |
| `capture-traffic.sh` | 代理与证书步骤 |
| `proto-extract.sh` | protobuf 类与 URL 线索 |
| `frida-hook-run.sh` | 注入已有脚本 |
| `server-bootstrap.sh` | Python 或 Node 最小服务端 |
| `tunnel-setup.sh` | frp 或 ngrok 配置 |

缺工具时的安装命令见 [tool-index.md](tool-index.md)。脚本失败必须把 stderr 原文写入案件 `logs/`，禁止改成「大概是证书问题」。

## 5. 协议笔记纪律

每条确认过的消息复制 [templates/protocol/PACKET.md](templates/protocol/PACKET.md) 到 `cases/<slug>/protocol/PKT-###.md`。没有笔记的 handler 视为未完成。

服务端实现必须符合 [handler-contract.md](references/handler-contract.md)：一个消息一个 handler，未知消息只记录并返回显式 stub，禁止静默丢弃。

登录链路的常见顺序见 [login-sequence.md](references/login-sequence.md)。按客户端实际崩溃点往下补，不要按想象一次实现几十个接口。

## 6. 卡住时

打开 [failure-catalog.md](references/failure-catalog.md)，用症状编号定位，只做该条的下一步。连续两次同一症状无新证据，停止改代码，回到上一阶段补证据。

## 7. 路由

| 片段 | 转交 |
|------|------|
| 只解包、smali、重签 | `apk-reverse` |
| IL2CPP 符号恢复 | `rev-u3d-dump` + [unity-il2cpp.md](references/unity-il2cpp.md) |
| 复杂 Frida 脚本 | `rev-frida` |
| 密码学细节 | `protocol-cryptanalysis` |
| 只做 UI 自动化 | `game-automation-scripting` |

## 8. 完成定义

复制并填完 [templates/report/ENGAGEMENT.md](templates/report/ENGAGEMENT.md)。至少包含：

- 授权依据（停服 / 自有 / 书面授权）
- triage JSON 路径
- 官方地址与本地地址的对应
- 协议笔记列表
- 已实现 handler 与仍未知的消息
- 启动命令与端口
- 未完成项与下一条证据

未填报告不得宣称闭环。

## 9. 禁止

- 跳过 legal-scope、案件目录、triage
- 对仍在运营的商业手游给出架设步骤
- 把某一款游戏的密钥、账号、抓包样本写入本仓库
- 在没有请求样本时编造字段号
- 用「再试一次」代替失败目录里的对症步骤
