# Playbook 04 · 最小服务端

目标：按笔记实现登录链，而不是按模板字段名。

读 [fake-server-patterns.md](../references/fake-server-patterns.md)、[handler-contract.md](../references/handler-contract.md)、[data-model.md](../references/data-model.md)。

## 步骤

1. 若 GitHub 已有**同版本**公开 emulator：读它的 handler 列表和许可证，能复用协议定义就复用。版本对不上就不要套它的字段。
2. 生成骨架到案件目录：

```bash
bash scripts/server-bootstrap.sh --slug <slug> --lang python --out cases/<slug>/server
```

HTTP/JSON 用 python 或 node。长连接 TCP 仍可用该进程做 HTTP 调试，另写一个只负责切帧的监听，逻辑调用同一 repository。

3. 把模板里的 `/api/login`、`token`、`roles` 改成 PKT 里的路径和字段名。对不上的占位删掉，避免客户端吃到错误字段还显示成功。
4. 按 login-sequence 一次加一跳。每加一跳：
   - 重启服务端
   - 看客户端是否进入下一界面
   - 把结果写进该 PKT 的「实现」节
5. 未知消息进入 `inbox` 表或日志，然后建新 PKT。
6. 表结构变更前复制 sqlite。

## 启动记录

写进 `REPORT.md`：

```bash
cd cases/<slug>/server
python3 -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
uvicorn main:app --host 0.0.0.0 --port 8080
```

端口以你的笔记为准。

## 退出

阶段门禁里阶段 3 的四条。心跳未观察就不要宣称进了游戏。
