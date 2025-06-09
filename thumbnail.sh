#!/bin/bash
set -euo pipefail

echo "🎬 视频缩略图自动生成器"

# 1. 输入视频目录
read -rp "请输入要处理的视频根目录路径: " SEARCH_DIR
SEARCH_DIR="${SEARCH_DIR%/}"
if [ ! -d "$SEARCH_DIR" ]; then
  echo "❌ 视频目录不存在: $SEARCH_DIR"
  exit 1
fi

# 2. 输入缩略图输出目录
read -rp "请输入缩略图的输出目录路径: " OUTPUT_DIR
OUTPUT_DIR="${OUTPUT_DIR%/}"
mkdir -p "$OUTPUT_DIR"
if [ ! -d "$OUTPUT_DIR" ]; then
  echo "❌ 创建输出目录失败: $OUTPUT_DIR"
  exit 1
fi

# 3. 输入截图间隔（秒）
read -rp "请输入截图时间间隔（秒，例如 10 表示每 10 秒一帧）: " INTERVAL
if ! [[ "$INTERVAL" =~ ^[0-9]+$ ]]; then
  echo "❌ 截图间隔必须为正整数"
  exit 1
fi

# 4. 搜索所有视频文件（常见格式）
VIDEO_LIST=()
while IFS= read -r -d '' file; do
  VIDEO_LIST+=("$file")
done < <(find "$SEARCH_DIR" -type f \( -iname '*.mp4' -o -iname '*.mkv' -o -iname '*.avi' -o -iname '*.mov' \) -print0)

if [ ${#VIDEO_LIST[@]} -eq 0 ]; then
  echo "⚠️ 未找到视频文件。"
  exit 0
fi

# 5. 缩略图生成函数
gen_thumbnail() {
  VIDEO="$1"
  REL_PATH="${VIDEO#$SEARCH_DIR/}"
  BASENAME="$(basename "$VIDEO" | sed 's/\.[^.]*$//')"  # 去扩展名
  TMPDIR=$(mktemp -d)

  # 判断是否是根目录视频
  if [[ "$REL_PATH" == "$BASENAME."* ]]; then
    OUTFILE="$OUTPUT_DIR/${BASENAME}.jpg"
  else
    SUBDIR="$(dirname "$REL_PATH")"
    mkdir -p "$OUTPUT_DIR/$SUBDIR"
    OUTFILE="$OUTPUT_DIR/$SUBDIR/${BASENAME}.jpg"
  fi

  # 生成截图
  ffmpeg -hide_banner -loglevel error -i "$VIDEO" \
    -vf "fps=1/$INTERVAL,drawtext=fontfile=/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf:text='%{pts\\:hms}':fontsize=24:fontcolor=black:x=10:y=10,scale=320:-1" \
    "$TMPDIR/thumb_%02d.png"

  # 拼图生成缩略图
  ffmpeg -hide_banner -loglevel error -pattern_type glob -i "$TMPDIR/thumb_*.png" \
    -vf "tile=4x6:padding=20:margin=20:color=white" -frames:v 1 "$OUTFILE"

  rm -rf "$TMPDIR"
  echo "[完成] $OUTFILE"
}

# 6. export 函数和变量供 parallel 使用
export -f gen_thumbnail
export SEARCH_DIR OUTPUT_DIR INTERVAL

# 7. 并行处理视频（最多同时 4 个）
printf "%s\n" "${VIDEO_LIST[@]}" | parallel --bar -j 4 gen_thumbnail {}

