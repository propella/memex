#!/usr/bin/env bash
# preview.sh - Quartz ローカルプレビューサーバーを起動する
# config ファイルを submodule にコピーしてからビルドする

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

# quartz.config.ts / quartz.layout.ts を submodule にコピー
cp "$REPO_ROOT/quartz.config.ts" "$REPO_ROOT/quartz/quartz.config.ts"
cp "$REPO_ROOT/quartz.layout.ts" "$REPO_ROOT/quartz/quartz.layout.ts"

# Node v22 で起動
source ~/.nvm/nvm.sh
nvm use 22

cd "$REPO_ROOT/quartz"
node quartz/bootstrap-cli.mjs build \
  -d "$REPO_ROOT/content" \
  --serve \
  "$@"
