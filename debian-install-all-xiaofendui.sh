#!/bin/bash
set -euo pipefail

echo "🔧 正在更新系统软件源..."
apt update && apt install -y sudo curl gnupg lsb-release ca-certificates software-properties-common apt-transport-https

echo "📦 安装 qBittorrent-nox..."
apt install -y qbittorrent-nox

echo "🛠️ 创建 qBittorrent systemd 服务..."
cat >/etc/systemd/system/qbittorrent-nox.service <<EOL
[Unit]
Description=qBittorrent-nox
After=network.target

[Service]
User=root
Type=forking
RemainAfterExit=yes
ExecStart=/usr/bin/qbittorrent-nox -d

[Install]
WantedBy=multi-user.target
EOL

systemctl daemon-reload
systemctl enable qbittorrent-nox
systemctl start qbittorrent-nox

echo "✅ qBittorrent 安装并已启动，默认 Web UI: http://<你的IP>:8080"
echo "   默认账号：admin 密码：adminadmin"

echo "🐳 安装 Docker（官方脚本）..."
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

echo "🚀 运行 Vertex 容器（端口: 5000）..."
docker run -d \
  --name vertex \
  -v /root/vertex:/vertex \
  -p 5000:3000 \
  -e TZ=Asia/Shanghai \
  --restart=always \
  lswl/vertex:stable

echo "🎉 安装完成！"
echo "📍 qBittorrent Web: http://<你的IP>:8080"
echo "📍 Vertex Web:     http://<你的IP>:5000"
sleep 5
echo "🔑 Vertex 容器密码（来自 /root/vertex/data/password）："
if [ -f /root/vertex/data/password ]; then
  cat /root/vertex/data/password
else
  echo "❌ 文件 /root/vertex/data/password 不存在"
fi
sleep 2
echo "📍 项目地址: https://github.com/wsdbb72/debian-install-scripts-xiaofendui"
