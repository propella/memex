# memex - my personal external memory

公開ページ: https://memex.tak-ed1.workers.dev/

## Goals

* 毎週更新しても苦にならないくらい簡単に文書を記録し、発表できるようにしたい。
* 今までに書いた文章が色んなところに散逸しているのでまとめたい。
* これからも文章をはてなブログや Qiita に書くと同時に Git レポジトリにもまとめて管理しやすくしたい。

## Requirements

この手のものを Digital Garden と呼ぶらしい。以下の条件で管理方法を検討する。

* 毎週更新で 10 年以上管理できること。
* テキストは GitHub で管理する。
* 動画は youtube へのリンク。
* 文書編集ツールとして、VIM, Visual Studio Code, Obsidian を利用する。
* 画像も結構あるので管理方法を検討する。現在 Google Photos に入っているが、Cloudflare R2 等を使っても良い。
    * 100KB を超える画像は Git で管理しない。
    * 画像は Google Drive などのクラウドストレージでバックアップしたい。
* ジャンルごとにコミュニティサイトに投稿したい。
    * 例えば技術記事 → qiita
    * アート → hackaday など
* 大まかには以下のカテゴリに分かれているのでサブディレクトリのルールを提案して欲しい。記事数が増えても整理できるように。
    * 既存の yamamiya.org を portfolio.yamamiya.org として整理した作品だけを載せる。
    * yamamiya.org/dev 技術より記事 qiita に発表したものなど
    * yamamiya.org/art キネティックアート「からくり計算機」や電子工作の制作記録。
    * yamamiya.org/note 雑記、近況、エッセイ。
    * ファイルは xxx/YYYY/MM-title.md に保存し、slug は日付を含まない形にする。
    * 現在 https://propella.blogspot.com/ にある少数の英語記事も別に置きたい。
* Static Site Generator の第一候補は Quartz、 Hugo、 Astro 将来変更の可能性あり。

## ローカルプレビュー

Node v22 が必要。初回クローン:

```bash
git clone --recurse-submodules git@github.com:propella/memex.git
```

すでにクローン済みの場合は submodule を初期化:

```bash
git submodule update --init
```

依存パッケージのインストール:

```bash
source ~/.nvm/nvm.sh && nvm use 22
cd quartz && npm install && cd ..
```

プレビューサーバーの起動:

```bash
./scripts/preview.sh
```

ブラウザで http://localhost:8080 を開く。

Quartz の設定変更は `quartz.config.ts` / `quartz.layout.ts` (memex root) を編集する。

## 記事を書く

Claude Code で `/new` を実行するとカテゴリ・タイトルを確認した上で記事のひな形を生成する。

## References

* [A Brief History & Ethos of the Digital Garden](https://maggieappleton.com/garden-history)
* [AS WE MAY THINK](https://worrydream.com/refs/Bush%20-%20As%20We%20May%20Think%20(Life%20Magazine%209-10-1945).pdf)
