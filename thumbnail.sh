#!/bin/bash
set -euo pipefail

# 1. 用户输入扫描路径
read -p "请输入要扫描的视频目录路径: " INPUT_PATH
SEARCH_DIR=$(echo "$INPUT_PATH" | sed "s/^['\"]//;s/['\"]$//")

if [ ! -d "$SEARCH_DIR" ]; then
  echo "❌ 目录不存在: $SEARCH_DIR"
  exit 1
fi

# 2. 用户输入输出路径
read -p "请输入缩略图输出目录路径: " OUTPUT_PATH
OUTPUT_DIR=$(echo "$OUTPUT_PATH" | sed "s/^['\"]//;s/['\"]$//")

mkdir -p "$OUTPUT_DIR"
if [ ! -d "$OUTPUT_DIR" ]; then
  echo "❌ 创建输出目录失败: $OUTPUT_DIR"
  exit 1
fi

# 3. 视频扩展名
EXTENSIONS="mp4|mkv|avi|mov|webm"

# 4. 查找所有视频文件（最多三级目录）
mapfile -t VIDEO_LIST < <(find "$SEARCH_DIR" -type f -regextype posix-extended -regex ".*\.($EXTENSIONS)")

TOTAL=${#VIDEO_LIST[@]}
if [ "$TOTAL" -eq 0 ]; then
  echo "⚠️ 没找到任何视频文件"
  exit 0
fi

echo "📦 共找到 $TOTAL 个视频，开始处理..."

# 5. 缩略图生成函数
gen_thumbnail() {
  VIDEO="$1"
  BASENAME=$(basename "$VIDEO")
  NAME="${BASENAME%.*}"

  # 找到一级目录（相对于用户输入路径）
  RELATIVE_PATH="${VIDEO#$SEARCH_DIR/}"
  TOPDIR="${RELATIVE_PATH%%/*}"
  # 特殊情况：视频就在根目录下
  if [ "$RELATIVE_PATH" = "$VIDEO" ]; then
    TOPDIR="root"
  fi

  OUTDIR="$OUTPUT_DIR/$TOPDIR/thumb"
  mkdir -p "$OUTDIR"
  OUTFILE="$OUTDIR/$NAME.png"

  # 跳过已存在
  if [ -f "$OUTFILE" ]; then
    echo "[跳过] $OUTFILE 已存在"
    return
  fi

  # 获取时长
  DURATION=$(ffprobe -v error -show_entries format=duration -of default=nw=1:nk=1 "$VIDEO" | awk '{printf("%d\n",$1)}')
  if [ -z "$DURATION" ] || [ "$DURATION" -le 10 ]; then
    echo "[跳过] $BASENAME 无效或过短"
    return
  fi

  INTERVAL=$(( DURATION / 24 ))
  [ "$INTERVAL" -lt 1 ] && INTERVAL=1

  TMPDIR=$(mktemp -d)

  # 生成截图
  ffmpeg -hide_banner -loglevel error -i "$VIDEO" \
    -vf "fps=1/$INTERVAL,drawtext=fontfile=/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf:text='%{pts\\:hms}':fontsize=24:fontcolor=black:x=10:y=10,scale=320:-1" \
    "$TMPDIR/thumb_%02d.png"

  # 拼图缩略图
  ffmpeg -hide_banner -loglevel error -pattern_type glob -i "$TMPDIR/thumb_*.png" \
    -vf "tile=4x6:padding=20:margin=20:color=white" -frames:v 1 "$OUTFILE"

  rm -rf "$TMPDIR"
  echo "[完成] $OUTFILE"
}

# 6. export 函数和变量供 parallel 使用
export -f gen_thumbnail
export SEARCH_DIR OUTPUT_DIR

# 7. 并行处理
printf "%s\n" "${VIDEO_LIST[@]}" | parallel --bar -j 4 gen_thumbnail {}

