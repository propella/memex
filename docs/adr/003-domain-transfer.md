# ADR-003: ドメイン移管の方針

- Date: 2026-03-15
- Status: Proposed

## Context

yamamiya.org のドメインは現在 Squarespace で登録・管理しており、DNS は Wix のネームサーバー（ns6/ns7.wixdns.net）に委任している。

ADR-002 にて Cloudflare Pages をホスティングプラットフォームとして採用することが決定した。Wix サイトを廃止するにあたり、Wix への DNS 委任も不要になる。ドメインをどこへ移管するか方針を定める必要がある。

### 現状の DNS レコード

| レコード | 値 | 用途 |
|---|---|---|
| A (apex) | 185.230.63.171 他 | Wix サーバー |
| CNAME (www) | cdn1.wixdns.net | Wix CDN |
| MX | mxa/mxb.mailgun.org | メール（Mailgun） |
| TXT/SPF | include:mailgun.org | Mailgun 送信認証 |

## Options

### Option A: DNS 管理のみ Cloudflare へ移行（登録は Squarespace のまま）

- ネームサーバーを Wix → Cloudflare に変更する
- ドメイン登録・更新は引き続き Squarespace で行う
- Cloudflare の DNS 管理は無料
- 作業: Squarespace 管理画面でネームサーバーを変更するだけ（即時反映、転送待ちなし）
- デメリット: 登録（Squarespace）と DNS・ホスティング（Cloudflare）で管理画面が分散する

### Option B: Cloudflare Registrar へドメイン移管

- ドメイン登録を Squarespace → Cloudflare Registrar へ移管する
- DNS・ホスティング・R2・ドメイン登録をすべて Cloudflare に集約できる
- Cloudflare Registrar は実費のみ（マークアップなし）のため、Squarespace より更新費が安い
- 作業: Squarespace で WHOIS ロック解除・認証コード取得 → Cloudflare で移管申請
- 移管完了まで 5〜7 日かかる
- デメリット: 移管手続きの手間、移管中は変更不可

### Option C: 現状維持（Wix DNS にレコードを追記）

- ネームサーバーは Wix のまま、A レコードを Cloudflare Pages の IP に書き換える
- デメリット: Squarespace（登録）・Wix（DNS）・Cloudflare（ホスティング）と 3 つのベンダーに分散する。管理の見通しが悪く、Wix との契約も継続が必要になる可能性がある

## Decision

**Option B: Cloudflare Registrar へドメイン移管** を推奨する。

登録・DNS・ホスティング・R2 をすべて Cloudflare に集約することで、管理画面が一元化される。ドメイン更新費も実費のみで長期的にコストを抑えられる。移管作業は一度だけの手間であり、移行後の恩恵が大きい。

ただし、ドメインの有効期限が 60 日以内の場合は移管が制限されるため、その場合は一時的に Option A を選択し、更新後に移管する。

## Consequences

### DNS 移行後のレコード構成

| レコード | 移行後の値 | 用途 |
|---|---|---|
| CNAME (apex / www) | Cloudflare Pages のドメイン | Cloudflare Pages でホスティング |
| MX | mxa/mxb.mailgun.org | メール（Mailgun）— **変更なし** |
| TXT/SPF | include:mailgun.org | Mailgun 送信認証 — **変更なし** |

### 手順概要（Option B）

**フェーズ 1: レジストラ移管（5〜7 日）**

1. Squarespace 管理画面でドメインの WHOIS ロックを解除し、認証コード（EPP コード）を取得する
2. Cloudflare Registrar でドメイン移管を申請し、EPP コードを入力する
3. 移管完了を待つ（この間 DNS は Wix のまま。サイトは Wix が引き続き応答する）
   - 移管はレジストラ（登録管理権）の変更のみであり、DNS ゾーンレコードには一切触れない
   - 移管完了直後もネームサーバーは ns6/ns7.wixdns.net のまま残る

**フェーズ 2: DNS 切り替え**

4. Cloudflare の DNS 管理画面を開く（移管後に有効になる）
   - Cloudflare が既存の Wix DNS レコードを自動スキャンしてインポートを提案する
   - 提案内容を確認し、不要なレコード（Wix の A/CNAME）を削除、必要なレコード（Mailgun の MX/TXT）を維持する
5. Cloudflare DNS に以下のレコードを設定する（上記テーブル参照）
6. Cloudflare Pages のカスタムドメインに yamamiya.org を設定する
7. ネームサーバーを Wix → Cloudflare に変更する（DNS 伝播: 最大 48 時間）
   - 伝播中は古い Wix レコードが参照されるため、サービス断は発生しない
