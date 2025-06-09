<h1 align="center">📦 BT Tools All-in-One</h1>
<p align="center">
  <em>一站式工具集：qBittorrent、Vertex Tracker、种子/缩略图自动生成</em>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/platform-Debian%20%7C%20Ubuntu-blue?style=flat-square">
  <img src="https://img.shields.io/badge/status-active-brightgreen?style=flat-square">
  <img src="https://img.shields.io/badge/auto--install-supported-orange?style=flat-square">
</p>

---

## 🔧 1. 自动安装 qBittorrent (无头版)

> 适合运行在服务器端，通过 Web UI 远程管理种子下载任务。

### ✨ 特性

- 安装最新版 `qBittorrent-nox`
- 设置默认 Web UI 端口 `8080`
- 自动添加 systemd 服务

### ▶️ 使用方式

```bash
bash install_qbittorrent.sh
```

安装完成后你可以通过浏览器访问：
```
http://你的服务器IP:8080
默认用户名: admin
默认密码: adminadmin
```

> ⚠️ 建议登录后立即修改密码！

---

## 🚢 2. 一键部署 Vertex Tracker (Docker)

> Vertex 是一个现代化、高性能、低资源占用的 BT Tracker 与私种管理器。

### ✨ 特性

- Docker 部署，无依赖污染
- Web 界面管理 Tracker、用户和种子
- 轻量 + 现代化 UI

### ▶️ 使用方式

```bash
bash install_vertex_docker.sh
```

部署完成后访问：
```
http://你的服务器IP:9000
```

默认管理员账户和密码可在脚本末尾查看或初始化配置中设置。

---

## 🧲 3. 自动制作种子脚本

> 基于 `mktorrent`，快速为目录批量生成 `.torrent` 文件。

### ✨ 特性

- 自动检查数据目录 & 输出目录
- 强制要求输入 Tracker 地址（不提供默认）
- 输出文件以目录名命名
- 可与 qBittorrent 和 Vertex 联动使用

### ▶️ 使用方式

```bash
bash generate_torrent.sh
```

运行后脚本会提示你输入：

- 要打包为种子的目录路径
- 输出 `.torrent` 文件保存路径
- Tracker 地址（必须填写）

---

## 📸 附加工具：缩略图生成器

使用 `ffmpeg` + `parallel` 批量为视频生成拼接缩略图，详情见 [`generate_thumbnails.sh`](./generate_thumbnails.sh)

---

## 🧱 系统要求

- 操作系统：Debian / Ubuntu / WSL2
- 权限：需要 sudo 权限
- 推荐环境：CPU 2C+ / 内存 1GB+

---

## 📄 License

MIT License. 随意魔改、打包、搭 tracker 发种都可以 😎
