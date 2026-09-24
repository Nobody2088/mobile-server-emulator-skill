# 阶段 4：穿透与多人联机

按 [playbooks/05-tunnel.md](../playbooks/05-tunnel.md)。本机闭环之前不要开公网端口。失败对 `F-TUNNEL-*`。

## 本地开发（同一台电脑）

```bash
# 模拟器访问 PC 上的 8080
adb reverse tcp:8080 tcp:8080
adb reverse tcp:9000 tcp:9000

# 查看
adb reverse --list
```

MuMu 等模拟器常用 `127.0.0.1:7555`：`adb connect 127.0.0.1:7555`

## DNS 免改包（局域网）

- 路由器自定义 DNS 或 dnsmasq：`address=/game-api.example.com/192.168.1.100`
- 手机 WiFi 手动 DNS 指向你的 dnsmasq 主机
- 详见 [client-redirect.md](client-redirect.md)

## 内网穿透（跨互联网）

| 工具 | 特点 |
|------|------|
| frp | 自建 VPS，稳定，多端口 |
| ngrok | 开箱即用，免费 tier 有限 |
| nps | 国产，Web 管理 |

```bash
bash scripts/tunnel-setup.sh --tool frp --local-port 8080 --remote-port 8080 --out ./tunnel
```

模板见 `templates/config/frpc.example.toml`。

## 多人联机要点

- **单一事实源**：角色数据只在你的服务端 DB，穿透层无状态
- **分发给朋友**：改 APK 中的域名为你的公网 IP/域名，或共用 VPN
- **端口**：HTTP + 游戏 TCP 可能不同端口，frp 需映射多条

## 安全

- 私密 preservation 服务器不要暴露无鉴权 admin 接口
- 使用 frp token / TLS
- 不在公网泄露抓包样本与用户数据
