# Playbook 02 · 重定向

目标：客户端的游戏连接打到你的机器。官方主机名可以不变，解析或下一跳必须是你。

先读 [client-redirect.md](../references/client-redirect.md)。Unity 再读 [unity-il2cpp.md](../references/unity-il2cpp.md)。

## 选择顺序

只选一条，做成后再换：

1. **同一台电脑 + 模拟器**：`adb reverse tcp:<port> tcp:<port>`。不改包。
2. **局域网 DNS / hosts**：官方域名指向你的电脑。适合域名写死、证书校验不绑 IP 的情况。
3. **改资源配置**：`assets` / `res` 里有完整 URL。用 `patch-endpoint.sh --mode report` 列出命中，再决定改哪些文件。
4. **改原生字符串或运行时连接**：留给 IL2CPP / so。先把字符串和偏移记到 `client/redirect-notes.md`。真正改字节前确认阶段门禁，并优先尝试 1 或 2。

## 命令

```bash
bash scripts/decode-client.sh cases/<slug>/client/apk/game.apk --out cases/<slug>/client
bash scripts/patch-endpoint.sh --mode report --dir cases/<slug>/client/apktool_out
```

DNS 方案只生成说明，不改路由器，除非操作者明确要求：

```bash
bash scripts/patch-endpoint.sh --mode dns --old https://game.example --new 192.168.1.10
```

## 必须写下的对照表

`client/redirect-notes.md`：

| 角色 | 官方 | 现在指向 | 证据 |
|------|------|----------|------|
| 登录服 | | | EV-RED-1 |
| 游戏服 | | | |
| 资源 CDN | | | 可后补 |

## 退出

logcat 或代理里出现**你的**地址。只有「文件已修改」不算退出。失败用 `F-REDIRECT-*`。
