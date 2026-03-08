# ディレクトリ構造と利用ツールの決定

## 課題

* 利用ツールを決定する。
* ディレクトリ構造を決定する。
    * 特に、画像ファイル入りの記事を簡単にローカルでプレビュー出来て、かつ簡単にクラウドストレージにアップロードできる構成にする。

## 開発プラン

### 利用ツールの決定

| 用途 | ツール | 備考 |
|------|--------|------|
| Static Site Generator | Quartz (第一候補) | Obsidian との親和性が高い |
| テキスト編集 | VIM / VSCode / Obsidian | 既存の好みに合わせる |
| テキスト管理 | GitHub (Git) | 100KB 超の画像は除く |
| 画像ストレージ | Cloudflare R2 | Git 管理外、CDN 配信可能 |
| 動画 | YouTube リンク | Git に含めない |
| 英語記事デプロイ | GitHub Pages / Cloudflare Pages | Quartz でビルド |

### ディレクトリ構造

```
memex/
├── README.md
├── .claude/
│   └── plans/
├── content/                  # Quartz のコンテンツルート
│   ├── index.md              # トップページ
│   ├── dev/                  # 技術記事 (yamamiya.org/dev)
│   │   └── YYYY/
│   │       └── MM-title.md
│   ├── art/                  # キネティックアート・電子工作 (yamamiya.org/art)
│   │   └── YYYY/
│   │       └── MM-title.md
│   ├── note/                 # 雑記・エッセイ (yamamiya.org/note)
│   │   └── YYYY/
│   │       └── MM-title.md
│   ├── portfolio/            # 作品集 (portfolio.yamamiya.org)
│   │   └── YYYY/
│   │       └── MM-title.md
│   └── en/                   # 英語記事 (propella.blogspot.com 移行分)
│       └── YYYY/
│           └── MM-title.md
├── quartz/                   # Quartz 設定・テーマ (git submodule or clone)
├── scripts/
│   └── upload-images.sh      # ローカル画像を R2 にアップロードするスクリプト
└── .gitignore                # 画像ファイル (*.jpg, *.png 等) を除外
```

### 画像管理の方針

**問題**: 画像入り記事をローカルでプレビューしながら、Git には含めず R2 で配信したい。

**方針**:
1. 記事執筆中は画像を `content/dev/YYYY/assets/` などのローカルパスに置く
2. Markdown 内では相対パスで参照する (`![](assets/foo.png)`)
3. `scripts/upload-images.sh` で R2 にアップロードし、URL を取得する
4. アップロード後、スクリプトが Markdown 内の相対パスを R2 URL に書き換える
5. `.gitignore` で `content/**/assets/` を除外し、Git には画像を含めない

**ローカルプレビュー**: Quartz の開発サーバー (`npx quartz build --serve`) でそのまま表示可能

### フロントマター規約

```yaml
---
title: "記事タイトル"
date: YYYY-MM-DD
slug: kebab-case-title   # 日付を含まない
tags: [dev, python]
draft: false
---
```

### slug とパーマリンク

- ファイル名: `MM-title.md` (日付でソート用)
- パーマリンク: `/dev/YYYY/kebab-case-title` (日付なし slug をフロントマターで指定)

### テスト用サンプル記事

- dev: https://qiita.com/propella/items/01a8a5fa0836a702813d
- art: https://propella.hatenablog.com/entry/2019/07/15/232143
- note: https://propella.hatenablog.com/entry/20081206/p1
- portfolio: https://www.yamamiya.org/?pgid=l30ms6lp1-27d728a7-f20c-42e0-8ba0-ef71b7f482e0
- en: https://propella.blogspot.com/2011/12/flapjax-vs-tangle.html

### 実装タスク

- [x] Quartz をセットアップする (`quartz/` サブディレクトリ、Node v22、`-d ../content` で起動)
- [x] ディレクトリ構造を作成する (`content/dev`, `art`, `note`, `portfolio`, `en`)
- [x] `.gitignore` に画像ファイルのパターンを追加する
- [x] `scripts/upload-images.sh` を作成する (ローカル画像 → R2 アップロード + URL 置換)
- [x] サンプル記事を各カテゴリに 1 つずつ作成してプレビューを確認する (HTTP 200 確認済み)
- [ ] Cloudflare R2 バケットを作成し、アップロードスクリプトを動作確認する
- [ ] Cloudflare Pages / GitHub Pages でデプロイパイプラインを設定する
