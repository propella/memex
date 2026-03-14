---
title: "自分の書いた物をまとめたい"
date: 2026-03-10
slug: building-digital-garden
tags: [dev, quartz, digital-garden, obsidian]
draft: false
---

私は今まで、はてなブログや Qiita など、いろいろな場所に自分の書いた文章を置いてきました。あまりバラバラだと後で探しにくいなというのと、最近流行りの Claude Code なんかと会話するためにまとまっていた方が何かと便利でしょという事で GitHub にまとめる事にしました。そこで以下の事を考えました。

* 今までに書いた文章が色んなところに散逸しているのでまとめたい。
* これからも文章をはてなブログや Qiita に書くと同時に Git レポジトリにもまとめて管理しやすくしたい。
* 毎週更新しても苦にならないくらい簡単に文書を記録し、発表できるようにしたい。
* 映像や写真は GitHub で管理しずらいので、何とか別の方法を考える。

## 基本構造

Chat GPT と相談した結果、私のやりたい事は [Digital Garden](https://maggieappleton.com/garden-history) というのと似ている事が分かりました。また、GitHub Pages として整形する場合のおすすめは [Quartz](https://quartz.jzhao.xyz/) というツールでした。特に好みは無いので素直に従う事にします。

## 写真

ビデオは YouTube と最初から考えていましたが、画像はよく分かりませんでした。Chat GPT のおすすめは Cloudflare R2 に置いてリンクを貼るという事なのでこの線で進めます。https://www.cloudflare.com を使うのは初めてです。

とりあえず Cloudflare にアカウントを作ってみました。

次に R2 バケットを作成します。Cloudflare のダッシュボードからクレジットカード情報を入力し、 R2 を有効にしてから、wrangler という CLI ツールで操作します。

```bash
npm install --save-dev wrangler
npx wrangler login
npx wrangler r2 bucket create memex-assets
```

`wrangler login` を実行するとブラウザが開いて OAuth 認証が行われます。バケット作成後、ダッシュボードの Settings > Public Development URL > Enable でパブリック URL を有効にします。今回発行された URL は `https://pub-d57c6c29d622472c8cfe58ae7483dd64.r2.dev` でした。

## ページの公開

サイト自体の公開には当初 GitHub Pages を使おうと思っていましたが Cloudflare Pages の方が便利そうなので変えました。以下設定メモです。

* https://dash.cloudflare.com に行く
* Workers & Pages → Create application → Connect to Git: レポジトリを選択 → Install & Authorize
* GitHub レポジトリを選択
* Build command: cd quartz && npx quartz build -d ../content
* Path: デフォルト
* ここで一度デプロイが走る。
* この設定には Workers & Pages > (プロジェクト) > Settings > Build Configuration で戻れる。
* 再デプロイ: Workers & Pages > (プロジェクト) Latest build failed > Retry Build
