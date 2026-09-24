# 阶段 3：最小服务端模式

按 [playbooks/04-server.md](../playbooks/04-server.md)、[handler-contract.md](handler-contract.md)、[data-model.md](data-model.md) 执行。登录顺序见 [login-sequence.md](login-sequence.md)。

目标：用与协议笔记一致的响应，让客户端走完登录、角色、心跳。

## 闭环优先级

1. **登录** — 任意账号返回 success + token/sessionId
2. **角色列表** — 返回至少一个角色或空列表可创建
3. **进场** — 返回等级、金币、地图 ID 等初始 state
4. **静态资源** — CDN 路径可 404 但核心 API 必须 200

不要一开始实现全部几百个 API；按客户端 crash/log 逐个补 handler。

## 架构分层

```
Transport (TCP/HTTP/WS)
  → Framing (length-prefix / JSON envelope)
    → Router (packetId / path → handler)
      → Service (business logic)
        → Repository (SQLite / JSON files)
```

## Handler 模式

| 类型 | 示例 |
|------|------|
| Echo | 原样返回空 protobuf |
| Stub | 固定 JSON：`{ "code": 0, "gold": 999999 }` |
| Proxy | 转发到官方 CDN（仅静态资源） |
| Stateful | 读写 SQLite 角色表 |

## 语言选型

| 语言 | 适合 |
|------|------|
| Python FastAPI | HTTP API、快速原型 |
| Node Express | WebSocket + JSON |
| Go | 高并发 TCP、参照 Belfast 类项目 |
| C# ASP.NET | Unity IL2CPP 同类栈 |

## Bootstrap

```bash
bash scripts/server-bootstrap.sh --slug mygame --lang python --out ./mygame_server
cd mygame_server && pip install -r requirements.txt && uvicorn main:app --reload
```

## 调试循环

1. 客户端发请求 → 服务端 log 未识别 packet/path
2. 对照抓包 hex 或开源项目补 handler
3. 重启服务端，重复直到过登录屏

## 持久化

- SQLite 单文件足够 preservation 联机
- 多玩家：所有 session 共库，用 `account_id` 隔离
