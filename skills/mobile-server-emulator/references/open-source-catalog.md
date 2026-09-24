# 开源 Server Emulator 检索指南

开始写服务端之前，**先搜 GitHub**，很多停服游戏已有 preservation 项目。

## 搜索关键词

```
"<游戏英文名>" server emulator
"<游戏英文名>" private server
"<包名>" protobuf
"<游戏名>" revival project
game preservation android
```

## 已知类型案例（学习架构，非通用插件）

| 类型 | 参考方向 |
|------|----------|
| Unity IL2CPP + TCP | Witcher Monster Slayer Revival（Frida + ASP.NET TCP） |
| Protobuf + .NET | Idle 类卡牌 Idle.Emu |
| Go + 自定义帧 | Azur Lane 方向 Belfast（技术博客） |
| Blowfish HTTP + Socket.IO | Monster Hunter Explore Apypos |
| DNS 劫持 + Python | Egg, Inc. reEgg |

## 如何使用开源项目

1. Clone 后读 `README` 的 client patch 与 server 启动步骤
2. 对照其 packet handler 目录结构
3. 只 fork 协议层，不要假设加密相同
4. 遵守项目 LICENSE 与 preservation 声明

## 无现成项目时

按本 skill 四阶段从零推进；优先实现 login handler，其余按 log 补全。
