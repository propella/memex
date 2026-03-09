---
title: "Quartz で Digital Garden を作った"
date: 2026-03-10
slug: building-digital-garden
tags: [dev, quartz, digital-garden, obsidian]
draft: false
---

以前からメモや文章を一箇所にまとめて公開したいと思っていた。ブログのように完成した記事を投稿するのではなく、育てながら育てていく「庭」のような場所 ― それが [Digital Garden](https://maggieappleton.com/garden-history) というコンセプトだ。

この記事では、その Digital Garden をどう作ったかをまとめる。

## 目標

- Markdown で書いてローカルでプレビューし、最小限の手間で公開する
- コンテンツとツールを分離する（ジェネレーターをあとから変えても困らない構成にする）
- 画像を Git リポジトリに入れずにきれいに扱う
- URL を安定させる（古いリンクが切れない）

## ツール選定

Hugo、Astro などを検討した結果、**[Quartz](https://quartz.jzhao.xyz/)** (v4) を選んだ。Digital Garden 向けに設計されており、`[[wikilink]]` スタイルのリンクや Obsidian との親和性が高い。出力は素の HTML なので、JavaScript フレームワークに依存しない点も気に入っている。

画像ホスティングには **Cloudflare R2** を使うことにした。画像を Git に入れず CDN で配信でき、自分のスケールなら費用はほぼゼロだ。

## ディレクトリ構造

```
memex/
├── content/          # Quartz のコンテンツルート (Git 管理)
│   ├── index.md
│   ├── dev/          # 技術記事
│   │   └── YYYY/
│   │       └── MM-title.md
│   ├── art/          # キネティックアート・電子工作
│   ├── note/         # 雑記・エッセイ
│   ├── portfolio/    # 作品集
│   └── en/           # 英語記事
├── quartz/           # Quartz (git submodule)
└── scripts/
    └── upload-images.sh
```

ファイル名を `YYYY/MM-title.md` にすることで、ファイルブラウザでも日付順に並ぶ。URL は日付なしにしたいので、パーマリンクはフロントマターの `slug` で指定する。

```yaml
---
title: "Quartz で Digital Garden を作った"
date: 2026-03-10
slug: building-digital-garden
tags: [dev, quartz, digital-garden]
draft: false
---
```

## 画像の扱い

画像の管理が一番悩んだ点だった。やりたいことは次の三つ。

1. ローカル執筆時に画像をプレビューできる（Obsidian や `npx quartz build --serve` で）
2. Git に画像バイナリを入れない
3. 本番では CDN 配信する

解決策として、執筆中は相対パス（`![](assets/foo.png)`）で書き、コミット前に `scripts/upload-images.sh` を実行する。このスクリプトが画像を R2 にアップロードし、Markdown 内のパスを R2 の URL に書き換える。

```
content/dev/2026/assets/   ← ローカルのみ、.gitignore で除外
```

`.gitignore` に `content/**/assets/` を追加してあるので、画像がリポジトリに紛れ込むことはない。

## Quartz のセットアップ

```bash
git submodule add https://github.com/jackyzha0/quartz.git quartz
cd quartz
npm install
```

Quartz はデフォルトで `quartz/content/` 以下にコンテンツを置くが、`-d` フラグで別のディレクトリを指定できる。

```bash
npx quartz build --serve -d ../content
```

こうするとコンテンツをリポジトリルートに置けて、Quartz 本体と分離できる。将来ジェネレーターを変えたくなっても、`content/` ディレクトリをそのまま移行できる。

## 今後の予定

- Cloudflare Pages でプッシュ時に自動デプロイする仕組みを作る
- R2 アップロードスクリプトを実際に動かして画像フローを確認する
- 記事を書き続ける ― 庭に植物が必要だ

このサイトのソースは [github.com/propella/memex](https://github.com/propella/memex) にある。
