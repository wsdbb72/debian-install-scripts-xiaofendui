#!/bin/bash
set -euo pipefail

echo "🎯 mktorrent 自动生成器"

# 1. 输入数据目录
read -rp "请输入要打包为种子的数据目录路径: " DATA_DIR
DATA_DIR="${DATA_DIR%/}"  # 去除尾部斜杠

if [ ! -d "$DATA_DIR" ]; then
  echo "❌ 数据目录不存在: $DATA_DIR"
  exit 1
fi

# 2. 输入种子输出目录
read -rp "请输入种子文件的输出目录路径: " OUTPUT_DIR
OUTPUT_DIR="${OUTPUT_DIR%/}"

mkdir -p "$OUTPUT_DIR"
if [ ! -d "$OUTPUT_DIR" ]; then
  echo "❌ 创建输出目录失败: $OUTPUT_DIR"
  exit 1
fi

# 3. 输入 Tracker 地址（必填）
read -rp "请输入 Tracker 地址（如：http://example.com/announce）: " TRACKER
if [ -z "$TRACKER" ]; then
  echo "❌ 必须提供一个 Tracker 地址。"
  exit 1
fi

# 4. 构建种子文件路径
TORRENT_NAME="$(basename "$DATA_DIR").torrent"
TORRENT_PATH="$OUTPUT_DIR/$TORRENT_NAME"

# 5. 运行 mktorrent
echo "🚀 正在生成种子文件..."
mktorrent -a "$TRACKER" -o "$TORRENT_PATH" "$DATA_DIR"

echo "✅ 种子文件已生成: $TORRENT_PATH"
echo "📍 项目地址: https://github.com/wsdbb72/debian-install-scripts-xiaofendui"

