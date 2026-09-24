# 协议笔记 PKT-___

- 编号：
- 版本三元组：
- 方向：C→S | S→C
- 传输：
- 上一条：
- 编码：JSON | Protobuf | 自定义帧 | 未解码
- 证据：`capture/samples/...`

## 观察

```text
长度:
前 16 字节:
帧头长度（未知则写未知）:
字段或 JSON:
```

## 客户端行为

- 成功时：
- 失败时（logcat 原文一行）：

## 实现

- handler：
- 结果：未做 | ok | protocol_error | unimplemented
- 验证：
