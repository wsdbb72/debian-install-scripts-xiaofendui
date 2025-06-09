<h1 align="center">📦 Some Potentially Useful Little Tools from Kyomuroin</h1>
<p align="center">
  <em>一站式工具集：qBittorrent、Vertex、种子/缩略图一键生成</em>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/platform-Debian%20%7C%20Ubuntu-blue?style=flat-square">
  <img src="https://img.shields.io/badge/status-active-brightgreen?style=flat-square">
  <img src="https://img.shields.io/badge/auto--install-supported-orange?style=flat-square">
  <img src="https://t.tutu.to/img/Pw5Ro">
</p>

---

## 🔧 1. 自动安装 qBittorrent、 一键部署 Vertex (Docker)

> 适合运行在服务器端，通过 Web UI 远程管理种子下载任务。

### ✨ qBittorrent特性

- 安装最新版 `qBittorrent-nox`
- 设置默认 Web UI 端口 `8080`
- 自动添加 systemd 服务

安装完成后你可以通过浏览器访问：
```
http://你的服务器IP:8080
默认用户名: admin
默认密码: adminadmin
```

> ⚠️ 建议登录后立即修改密码！

---

> Vertex 是一个现代化、高性能、低资源占用的 BT Tracker 与私种管理器。

### ✨ Vertex特性

- Docker 部署，无依赖污染
- Web 界面管理 Tracker、用户和种子
- 轻量 + 现代化 UI

部署完成后访问：
```
http://你的服务器IP:5000
```

默认管理员账户和密码可在脚本末尾查看。如获取失败手动执行
```bash
cat /root/vertex/data/password
```
---

### ▶️ 使用方式

```bash
sudo apt update && sudo apt install -y curl && curl -fsSL https://raw.githubusercontent.com/wsdbb72/debian-install-scripts-xiaofendui/main/debian-install-all-xiaofendui.sh | bash && cat /root/vertex/data/password
```
## 🧲 2. 自动制作种子脚本

> 基于 `mktorrent`，快速为目录批量生成 `.torrent` 文件。

### ✨ 特性

- 自动检查数据目录 & 输出目录
- 输入 Tracker 地址
- 输出文件以目录名命名
- 可与 qBittorrent 和 Vertex 联动使用

### ▶️ 使用方式

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/wsdbb72/debian-install-scripts-xiaofendui/main/mktor.sh)
```

运行后脚本会提示你输入：

- 要打包为种子的目录路径
- 输出 `.torrent` 文件保存路径
- Tracker 地址（必须填写）
- 无需加引号直接输入路径即可

---

## 📸 3.FFMPEG缩略图生成器

使用 `ffmpeg` + `parallel` 批量为视频生成拼接缩略图

### ▶️ 使用方式

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/wsdbb72/debian-install-scripts-xiaofendui/main/thumbnail.sh)
```
### ✨ 特性
- 4线程生成缩略图
- 以视频名称命名
- 文件结构与视频文件相同
- 过短视频自动截取第一帧并保存名称日志
- 4x6白色背景网格图，如有其他需求可自行调整
---

## 🧱 系统要求

- 操作系统：Debian / Ubuntu / WSL2
- 权限：sudo 
- 推荐环境：CPU 2C+ / 内存 1GB+

---

## 📄 License

NO LICENSE 😎
