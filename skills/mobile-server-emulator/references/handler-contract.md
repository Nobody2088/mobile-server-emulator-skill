# Handler 契约

一个消息一个函数。传输层只负责切帧和记日志。

## 1. 分层

```text
accept / HTTP router
  → frame_decode        只处理长度、魔数、压缩标志
    → message_decode    JSON 或 Protobuf，失败则记 PKT 并返回协议错误
      → handler         业务
        → repository    SQLite，见 data-model.md
      ← message_encode
    ← frame_encode
```

禁止在 HTTP 路由里手写字节序，禁止在 repository 里读 socket。

## 2. 函数形状

```text
handle_<message_name>(ctx) -> response | error
ctx.account_id     可空，登录前为空
ctx.request_id     日志用
ctx.body           已解码结构
ctx.raw            原始字节，仅调试
```

返回三种结果之一：

| 结果 | 何时 | 客户端可见 |
|------|------|------------|
| `ok` | 与笔记一致的成功包 | 进入下一界面 |
| `protocol_error` | 解码失败 | 日志 + 明确错误码，不假装成功 |
| `unimplemented` | 包已识别但逻辑未写 | 日志打出消息名；包体用笔记里的空成功或显式错误，二选一写进 PKT |

`unimplemented` 必须出现在 `REPORT.md` 的未完成列表。

## 3. 幂等

登录、领奖、创角按请求里的序号或业务 ID 去重。同一 `client_seq` 第二次返回第一次的结果，不重复加道具。没有序号时，在笔记里写「未观察到序号，暂不去重」。

## 4. 错误码

先沿用客户端已有字段：`code`、`ret`、`errorCode`。不要发明客户端不读的字段。未知时：

- HTTP：记录真实状态码。客户端把 401 当掉线、把 200 当成功，以观察为准。
- TCP：记录客户端收到错误包后的 logcat。

## 5. 日志行

每条消息一行，固定字段：

```text
ts request_id dir message bytes result account_id
```

不打印 token 全文。需要对照时只打印长度和前后 4 字节。

## 6. 与模板的关系

`templates/server-python/main.py` 与 `templates/server-node/server.js` 是骨架：

- `/health` 证明进程在听
- 登录与角色是占位，字段名必须改成 PKT 笔记里的名字
- 兜底路由只用于发现未知路径，发现后立刻加具名 handler，不要永远依赖兜底

生成后阅读 `server/README`，把端口和启动命令写进 `REPORT.md`。
