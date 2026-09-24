# Playbook 01 · Triage

目标：用证据确定引擎、版本、官方主机候选和下一阶段路径。不改包。

## 步骤

1. 确认 `00-scope.md` 是允许。
2. 把 APK 放到 `cases/<slug>/client/apk/`（目录已被 gitignore 覆盖时仍不要提交）。
3. 运行：

```bash
bash scripts/doctor.sh | tee cases/<slug>/00-doctor.json
bash scripts/triage-client.sh cases/<slug>/client/apk/game.apk | tee cases/<slug>/01-triage.json
```

4. 若本机有 `aapt`：

```bash
aapt dump badging cases/<slug>/client/apk/game.apk | tee cases/<slug>/logs/badging.txt
```

5. 打开 [engine-fingerprint.md](../references/engine-fingerprint.md)，复核 `engine`。不一致就在 `client/engine.md` 写明以哪个文件为准。
6. 按 [open-source-catalog.md](../references/open-source-catalog.md) 搜索。把仓库 URL 或「无」写进 `REPORT.md`。
7. 读 [routing.md](../routing.md)，只打开下一阶段那一个 playbook。

## 合格输出

- `01-triage.json` 含 `package`、`engine`、`recommended_path`
- 版本三元组：versionName、versionCode、ABI
- 公开项目检索结论

## 停止

- APK 不是 zip：停止，不跑 jadx
- 授权不清：回到 legal-scope
