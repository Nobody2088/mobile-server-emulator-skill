# 关联社区技能

本 skill 覆盖「手游服务端模拟」全流程；以下片段可转交专用 skill。

| 场景 | 技能 | 安装 |
|------|------|------|
| APK 解包 / smali / 重签 | apk-reverse | `npx skills add zhaoxuya520/reverse-skill --skill apk-reverse -g -y` |
| Unity IL2CPP 符号 | rev-u3d-dump | `npx skills add p4nda0s/reverse-skills --skill rev-u3d-dump -g -y` |
| Frida 脚本生成 | rev-frida | `npx skills add p4nda0s/reverse-skills --skill rev-frida -g -y` |
| HTTP API 提取 | android-reverse-engineering | SimoneAvogadro 仓库 |
| 协议 / 加密深度 | protocol-cryptanalysis | 本机 `~/.cursor/skills/` |
| UI 自动化（非私服） | game-automation-scripting | 本机 `~/.cursor/skills/` |

## 组合工作流示例

```
triage-client.sh → apk-reverse decode → rev-u3d-dump
  → capture-traffic + rev-frida → server-bootstrap → tunnel-setup
```
