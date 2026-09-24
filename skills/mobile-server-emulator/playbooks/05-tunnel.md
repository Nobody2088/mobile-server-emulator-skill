# Playbook 05 · 穿透与第二台设备

目标：在本机闭环之后，让另一网络里的客户端连到**同一**数据库。

先读 [tunnel-multiplayer.md](../references/tunnel-multiplayer.md)。

## 顺序

1. 本机 `adb reverse` 或局域网 IP 已经满足阶段 3。记录命令输出。
2. 需要跨公网时再生成配置：

```bash
bash scripts/tunnel-setup.sh \
  --tool frp \
  --local-port 8080 \
  --remote-port 8080 \
  --out cases/<slug>/tunnel
```

3. 编辑生成文件里的 VPS 地址和 token。token 留在案件目录，不提交、不贴进聊天。
4. 客户端里的主机改成公网地址或域名。登录响应里的下一跳一并改。
5. 第二台设备登录，确认 `account` 出现在同一个 sqlite。

## 端口表

| 用途 | 本地 | 远端 | 工具 | 证据 |
|------|------|------|------|------|
| HTTP API | 8080 | | | |
| 游戏 TCP | | | | |
| 资源 | | | | 可后补 |

## 退出

阶段 4 门禁。只有隧道进程在跑、没有第二台设备的登录记录，不算完成。
