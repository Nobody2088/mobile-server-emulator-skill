# 案件作业系统

一次目标一个目录。目录是唯一事实来源：脚本输出、协议笔记、服务端代码、阶段结论都在这里。技能仓库只放方法，不放用户 APK、pcap、keystore。

## 1. 建立

```bash
bash scripts/init-workspace.sh \
  --slug mygame \
  --title "Mygame preservation" \
  --out ./cases/mygame
```

`slug` 只用小写字母、数字、连字符。

## 2. 目录

```text
cases/<slug>/
├── 00-scope.md              # legal-scope 三行结论
├── 00-doctor.json           # doctor.sh
├── 01-triage.json           # triage-client.sh
├── REPORT.md                # 从 templates/report/ENGAGEMENT.md 复制
├── client/
│   ├── apk/                 # 原始包，gitignore
│   ├── jadx_out/
│   ├── apktool_out/
│   └── redirect-notes.md    # 官方地址 → 本地地址
├── capture/
│   ├── notes.md
│   └── samples/             # 脱敏后的 hex/json，不含账号令牌
├── protocol/
│   └── PKT-001.md           # 每条消息一份
├── server/                  # server-bootstrap 输出
├── tunnel/
│   └── frpc.generated.toml
└── logs/                    # 命令原文，失败也留
```

## 3. 证据编号

| 前缀 | 含义 | 例子 |
|------|------|------|
| `EV-DOC` | 工具与环境 | `00-doctor.json` |
| `EV-TRI` | 引擎指纹 | `01-triage.json` |
| `EV-RED` | 重定向生效 | logcat 里出现本地地址 |
| `EV-PKT` | 一条消息 | `protocol/PKT-003.md` |
| `EV-SRV` | handler 行为 | 请求路径、返回 JSON、时间 |
| `EV-TUN` | 端口映射 | `adb reverse --list` 或 frpc 状态 |

笔记里引用编号，不写「刚才抓到了」。

## 4. 命名

- 包名、版本、ABI 写在 `REPORT.md` 开头，后续命令都带这个版本。换包必须新开一节，不覆盖旧证据。
- 地址对照表固定三列：`官方主机`、`本地或穿透主机`、`证据编号`。
- Handler 名与消息名一致：`LoginReq` → `handle_login_req`。

## 5. 脱敏

写入仓库或聊天前删除：

- 账号、token、cookie、设备指纹
- 支付字段、真实玩家 ID
- 完整 pcap

样本只留长度、字段号、类型和你构造的测试值。

## 6. 会话怎么交接

新开一轮 Agent 时只给三样东西：

1. `00-scope.md` 结论
2. `REPORT.md` 里「当前阶段」
3. 最近一条失败的 `logs/` 文件名

不要靠聊天记录重建状态。
