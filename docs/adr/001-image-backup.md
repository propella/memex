# ADR-001: 画像ファイルのバックアップ戦略

- Date: 2026-03-14
- Status: Proposed

## Context

画像ファイルは `.gitignore` でリポジトリ管理外 (`content/**/assets/`) となっており、
Cloudflare R2 で配信している。しかしローカルに保存されている画像のバックアップ手段がない。

Git リポジトリを丸ごと Google Drive に同期する方法も考えられるが、以下のリスクがある:

- Google Drive の同期プロセスが `.git` ディレクトリの小ファイルを部分的に読み書きし、
  Git オブジェクトストアが壊れる可能性がある
- Git 操作と Google Drive 同期が同時に走ると競合が生じる

## Options

### Option A: rclone でリポジトリ内の assets だけを同期

画像は引き続き `content/**/assets/` に置いたまま、rclone で assets ディレクトリだけを Google Drive に同期する。

```bash
rclone sync ~/src/memex/content gdrive:memex-images \
  --include "**/assets/**"
```

- メリット: 現在のディレクトリ構成を変えなくてよい。記事と画像が同じ場所にある
- デメリット: rclone の `--include` フィルタの管理が必要。将来ディレクトリ構成が変わると同期設定も変える必要がある

### Option B: 画像をリポジトリ外に分離して Google Drive で同期

画像をリポジトリ外の別ディレクトリに置き、そのディレクトリを Google Drive Desktop で丸ごと同期する。

```
~/
├── src/memex/          ← Git 管理 (GitHub にプッシュ)
│   └── content/
│       └── dev/2026/   ← .md ファイルのみ
└── memex-assets/       ← 画像のみ (Google Drive でバックアップ)
    └── dev/2026/
```

記事からの参照は R2 URL か絶対パスで行う。

- メリット: Git リポジトリと画像が完全に分離。Google Drive Desktop で直感的に管理できる
- デメリット: 記事と画像が別の場所になり、ローカルプレビュー時の相対パス参照ができなくなる

## Decision

未決定

## Consequences

(決定後に記載)
