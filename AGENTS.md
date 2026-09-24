# Agent 入口

本仓库是 **mobile-server-emulator** 技能包。Agent 遇到手游服务端模拟、停服 preservation、协议还原、伪服务端搭建任务时，读取：

```
skills/mobile-server-emulator/SKILL.md
```

## 路由规则

| 用户意图 | 入口 |
|----------|------|
| 私服 / server emulator / private server | `SKILL.md` 四阶段工作流 |
| 只解 APK / 改 smali | 转交 `apk-reverse` |
| Unity IL2CPP 符号 | 读本 skill `references/unity-il2cpp.md` + `rev-u3d-dump` |
| 纯抓包 / 加密协议 | `references/protobuf-workflow.md` + `protocol-cryptanalysis` |

## 合规

执行任何步骤前必须先读 `skills/mobile-server-emulator/references/legal-scope.md`。
