# 数据模型

preservation 用一个 SQLite 文件。表只保留客户端真正读过的字段，其余放 JSON 列，避免过早拆表。

## 1. 最小表

```sql
CREATE TABLE account (
  id INTEGER PRIMARY KEY,
  username TEXT UNIQUE NOT NULL,
  token TEXT NOT NULL,
  created_at TEXT NOT NULL
);

CREATE TABLE character (
  id INTEGER PRIMARY KEY,
  account_id INTEGER NOT NULL REFERENCES account(id),
  name TEXT NOT NULL,
  level INTEGER NOT NULL DEFAULT 1,
  blob_json TEXT NOT NULL DEFAULT '{}'
);

CREATE TABLE inbox (
  id INTEGER PRIMARY KEY,
  account_id INTEGER NOT NULL,
  message_name TEXT NOT NULL,
  body_json TEXT NOT NULL,
  created_at TEXT NOT NULL
);
```

`blob_json` 放货币、关卡、背包等尚未稳定的结构。等同一字段被三个 handler 使用，再拆列。

## 2. 所有权

| 数据 | 写入者 | 读取者 |
|------|--------|--------|
| account / character | 登录与创角 handler | 后续所有需要身份的 handler |
| inbox | 任何收到但未实现的消息 | 人，用来补协议 |
| 穿透配置 | 不存业务 | — |

禁止把角色进度写进 frp 配置、环境变量或客户端包里。

## 3. 身份

登录成功后，后续请求用笔记里的字段认人：`token`、`uid`、`session`。对不上就返回笔记中的未登录形态，并打日志。不要新建一套客户端不认识的 header。

## 4. 多人

多个账号共用一个库，用 `account_id` 隔离。不要为每个朋友起一个进程。区服如果协议里存在，就做 `realm_id` 列；协议里没有就不要发明。

## 5. 备份

改表前复制 `*.sqlite`。案件目录里保留 `server/schema.sql` 与当前库文件名。
