#!/usr/bin/env bash
# upload-images.sh
# ローカルの assets/ フォルダ内画像を Cloudflare R2 にアップロードし、
# Markdown 内の相対パスを R2 URL に書き換える。
#
# 使い方:
#   ./scripts/upload-images.sh content/dev/2026/03-my-article.md
#   ./scripts/upload-images.sh          # 引数なしで content/ 以下の全 .md を対象

set -euo pipefail

R2_BUCKET="${R2_BUCKET:-memex-assets}"
R2_BASE_URL="${R2_BASE_URL:-https://pub-d57c6c29d622472c8cfe58ae7483dd64.r2.dev}"

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CONTENT_ROOT="$REPO_ROOT/content"

# 対象ファイルを決定
if [[ $# -gt 0 ]]; then
  targets=("$@")
else
  mapfile -t targets < <(find "$CONTENT_ROOT" -name "*.md")
fi

upload_and_replace() {
  local md_file="$1"
  local md_dir
  md_dir="$(dirname "$md_file")"
  local assets_dir="$md_dir/assets"

  if [[ ! -d "$assets_dir" ]]; then
    return
  fi

  echo "==> $md_file の assets/ を処理中..."

  while IFS= read -r -d '' img_file; do
    local img_filename
    img_filename="$(basename "$img_file")"
    local r2_key
    r2_key="${img_file#"$CONTENT_ROOT/"}"
    local r2_url="$R2_BASE_URL/$r2_key"

    echo "  アップロード: $img_filename -> $r2_url"
    npx wrangler r2 object put "$R2_BUCKET/$r2_key" --file "$img_file" --remote

    # Markdown 内の相対パスを R2 URL に置換
    sed -i '' "s|](assets/$img_filename)|]($r2_url)|g" "$md_file"
    sed -i '' "s|src=\"assets/$img_filename\"|src=\"$r2_url\"|g" "$md_file"

    echo "    完了: $img_filename"
  done < <(find "$assets_dir" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.gif" -o -name "*.webp" -o -name "*.svg" \) -print0)
}

for target in "${targets[@]}"; do
  upload_and_replace "$target"
done

echo "完了。"
