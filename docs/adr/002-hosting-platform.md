# ADR-002: ホスティングプラットフォームの選定

- Date: 2026-03-14
- Status: Accepted

## Context

Quartz でビルドした静的サイトを公開するためのホスティングプラットフォームを選定する必要がある。
候補は GitHub Pages と Cloudflare Pages。

画像は Cloudflare R2 で配信しており、ホスティングとの親和性も考慮する。

## Options

### Option A: GitHub Pages

- GitHub リポジトリと直接連携できる
- カスタムドメイン・HTTPS に対応
- ビルドは GitHub Actions で別途設定が必要
- CDN は Fastly（機能は限定的）
- R2 とは別エコシステム

### Option B: Cloudflare Pages

- Git リポジトリ連携だけでビルド・デプロイが完結する（内蔵ビルド環境）
- カスタムドメイン・HTTPS に対応
- Cloudflare CDN（世界最大級）による高速配信
- R2 と同一エコシステムのため、画像 CDN との連携がシンプル
- 無料枠: 500 ビルド/月（十分な余裕あり）

## Decision

**Option B: Cloudflare Pages** を採用する。

## Consequences

- Cloudflare アカウントに Pages プロジェクトを作成し、GitHub リポジトリを連携する
- ビルドコマンド: `npx quartz build`、出力ディレクトリ: `public`
- GitHub Actions の CI/CD 設定は不要
- R2・Pages・DNS がすべて Cloudflare で完結するため、設定箇所が一元化される
