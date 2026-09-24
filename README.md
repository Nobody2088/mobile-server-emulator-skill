# mobile-server-emulator-skill

通用 Agent 技能包：**手游服务端模拟器开发**（Server Emulator Development）。

兼容 Cursor、Codex、Claude Code、ZCode CLI 等支持 [Agent Skills](https://skills.sh/) 的客户端。

## 适用场景

- 已停服手游的 preservation / 私服研究（合法授权范围内）
- 自有 App 或靶场的协议分析与最小服务端搭建
- 学习公开 GitHub preservation 项目的方法论

**不适用于**仍在运营的商业手游未授权私服、伪造充值或分发改包牟利。

## 四阶段工作流

1. **客户端重定向** — 改 APK 地址 / DNS 劫持 / adb reverse
2. **抓包与协议还原** — HTTPS 解密、Protobuf、自定义帧
3. **最小伪服务端** — 登录闭环 → 角色数据 → 进场
4. **穿透与联机** — frp / ngrok / adb reverse

## 安装

### 全局（Cursor / Codex）

```bash
npx skills add Nobody2088/mobile-server-emulator-skill --skill mobile-server-emulator -g -y
```

或软链：

```bash
ln -sf ~/skills/mobile-server-emulator-skill/skills/mobile-server-emulator \
  ~/.cursor/skills/mobile-server-emulator
```

### 项目级

```bash
mkdir -p .agents/skills
ln -sf ~/skills/mobile-server-emulator-skill/skills/mobile-server-emulator \
  .agents/skills/mobile-server-emulator
```

## 快速开始

```bash
# 1. Triage APK
bash skills/mobile-server-emulator/scripts/triage-client.sh /path/to/game.apk

# 2. 解包
bash skills/mobile-server-emulator/scripts/decode-client.sh /path/to/game.apk

# 3. 生成服务端骨架
bash skills/mobile-server-emulator/scripts/server-bootstrap.sh \
  --slug mygame --lang python --out ./mygame_server
```

Agent 读到 `SKILL.md` 后会按 `routing.md` 自动路由四阶段。

## 目录结构

```
skills/mobile-server-emulator/
├── SKILL.md              # 主技能入口
├── tool-index.md         # 工具探测
├── routing.md            # 游戏类型路由
├── scripts/              # 可复用 CLI 脚本
├── references/           # 分模块文档
└── templates/            # 服务端 / Frida / 配置模板
```

## 相邻技能

| 任务 | 推荐技能 |
|------|----------|
| APK 解包 / smali | `apk-reverse` (zhaoxuya520/reverse-skill) |
| IL2CPP 符号 | `rev-u3d-dump` (p4nda0s/reverse-skills) |
| Frida 脚本 | `rev-frida` (p4nda0s/reverse-skills) |

## License

MIT — see [LICENSE](LICENSE).
