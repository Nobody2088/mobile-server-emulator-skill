# 阶段 1：客户端地址重定向

目标：让游戏客户端连接你的本地/穿透服务端，而不是官方域名。

## 决策树

```
有 root / 可改 DNS？
├─ 是 → 优先 DNS/hosts（免改 APK）
└─ 否 → 必须改包或 Frida hook connect()

引擎类型？
├─ 弱联网（JSON/XML 配置）→ assets/ 或 res/ 改 URL
├─ Unity IL2CPP → libil2cpp.so 字符串 patch 或 DNS
├─ Cocos / Lua → assets 脚本或 .so 字符串
└─ 原生 Java → smali / SharedPreferences / BuildConfig
```

## 弱联网手游

1. `apktool d game.apk -o apktool_out`
2. 搜索 `grep -r "http" apktool_out/assets apktool_out/res`
3. 修改 `.json` / `.xml` / `.lua` 中的 `serverUrl`、`api_host` 等
4. 重打包签名安装（见 `scripts/patch-endpoint.sh`）

## Unity IL2CPP

详见 [unity-il2cpp.md](unity-il2cpp.md)。常见域名在 `lib/*/libil2cpp.so` 明文字符串中。

## 免改包：DNS / hosts

- **路由器 DNS**：将 `game-api.example.com` → `192.168.x.x`
- **手机 hosts**（需 root）：`/system/etc/hosts`
- **AdAway / 私人 DNS**：部分游戏只校验域名不校验 IP
- **adb reverse**（本地开发）：`adb reverse tcp:8080 tcp:8080`

## Frida 重定向（不改 APK）

使用 `templates/frida/connect-redirect.js`：hook `connect()` 将官方 IP 替换为 `127.0.0.1:PORT`。

## 输出证据

- 修改的文件列表与前后 URL 对比
- 或 DNS 配置截图 / `adb reverse` 命令
- 客户端 logcat 中出现连向你的地址的连接尝试
