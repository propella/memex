#!/usr/bin/env bash
# upload-images.sh
# ローカルの assets/ フォルダ内画像を Cloudflare R2 にアップロードし、
# Markdown 内の相対パスを R2 URL に書き換える。
#
# 使い方:
#   ./scripts/upload-images.sh content/dev/2026/03-my-article.md
#   ./scripts/upload-images.sh          # 引数なしで content/ 以下の全 .md を対象
#
# 必要な環境変数:
#   R2_BUCKET   - R2 バケット名 (例: memex-assets)
#   R2_BASE_URL - R2 公開 URL のベース (例: https://assets.yamamiya.org)
#   AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_ENDPOINT_URL_S3
#     → Cloudflare R2 の S3 互換 API クレデンシャル

set -euo pipefail

: "${R2_BUCKET:?R2_BUCKET が未設定です}"
: "${R2_BASE_URL:?R2_BASE_URL が未設定です}"
: "${AWS_ACCESS_KEY_ID:?AWS_ACCESS_KEY_ID が未設定です}"
: "${AWS_SECRET_ACCESS_KEY:?AWS_SECRET_ACCESS_KEY が未設定です}"
: "${AWS_ENDPOINT_URL_S3:?AWS_ENDPOINT_URL_S3 が未設定です}"

CONTENT_ROOT="$(cd "$(dirname "$0")/.." && pwd)/content"

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
    # R2 上のキー: content/ からの相対パス (例: dev/2026/assets/foo.png)
    local r2_key
    r2_key="${img_file#"$CONTENT_ROOT/"}"
    local r2_url="$R2_BASE_URL/$r2_key"

    echo "  アップロード: $img_filename -> $r2_url"
    aws s3 cp "$img_file" "s3://$R2_BUCKET/$r2_key" \
      --endpoint-url "$AWS_ENDPOINT_URL_S3" \
      --acl public-read \
      --quiet

    # Markdown 内の相対パスを R2 URL に置換 (assets/xxx.ext -> https://...)
    sed -i '' "s|](assets/$img_filename)|]($r2_url)|g" "$md_file"
    sed -i '' "s|src=\"assets/$img_filename\"|src=\"$r2_url\"|g" "$md_file"

    echo "    完了: $img_filename"
  done < <(find "$assets_dir" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.gif" -o -name "*.webp" -o -name "*.svg" \) -print0)
}

for target in "${targets[@]}"; do
  upload_and_replace "$target"
done

echo "完了。"
