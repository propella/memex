---
title: "グリニッジ天文台に本初子午線は存在しない"
date: 2018-08-29
slug: greenwich-meridian
tags: [geography, gps, history]
draft: false
original_url: https://qiita.com/propella/items/01a8a5fa0836a702813d
---

![Airy's transit circle](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.amazonaws.com%2F0%2F35350%2F06ff5d83-bc50-5e29-ba6a-0387f7edb6dc.jpeg?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=b0ea15f408092a8104993a1c647a8d08)

[グリニッジ天文台](https://ja.wikipedia.org/wiki/%E3%82%B0%E3%83%AA%E3%83%8B%E3%83%83%E3%82%B8%E5%A4%A9%E6%96%87%E5%8F%B0)といえば世界標準時の観測地点として、または経度ゼロを決定する基準点として有名です。私達が日々お世話になっている時計や地図アプリが便利に使えるのも、このグリニッジ天文台のおかげなのです。その憧れのグリニッジ天文台ですが、ふと Wikipedia を眺めるとすでに天文台を辞めてしまっただけでなく、本初子午線(経度ゼロの線)すら通っていませんでした！現在では本初子午線は本来の観測器のあった場所から 102 メートルほど東の点にズレたそうです。

ズレた理由としては、[IERS基準子午線](https://ja.wikipedia.org/wiki/IERS%E5%9F%BA%E6%BA%96%E5%AD%90%E5%8D%88%E7%B7%9A)にこのような記載があります。

> "IRMとグリニッジ子午線との間の約5.3秒のずれは、グリニッジ子午線がグリニッジにおける局所的な鉛直を用いた局所座標系であったために生じたものである。"

これを読んでもさっぱり意味が分からなかったので自分なりに調べました。こういう事のようです。

- 昔は天体を観測する時、角度の基準として重力の方向を使っていた。
- 重力の方向は地下の様子によってゆらぎがあるため、GPS などでは地球の形に似た楕円体(の法線)を基準にした。
- GPS では、楕円体を基準にした座標を使っていたが、時刻はあい変わらずグリニッジ天文台の重力方向を基準にした標準時を使っていた。
- GPS で地点計測に使う時刻はグリニッジ天文台の重力方向を基準にしているので、そのまま楕円体を基準にして経度ゼロの位置を調べるとグリニッジ天文台より 102 メートル東にずれてしまった。

> "The 102-m offset between the Airy Transit Circle and zero longitude indicated by a GNSS receiver is attributable to the fact that continuity in the UT1 time series was maintained in the BIH reference frames, as geodetic longitudes replaced astronomical longitudes when space-geodetic methods were introduced."
> — [Why the Greenwich meridian moved](https://link.springer.com/article/10.1007%2Fs00190-015-0844-y)

ようするに、天体を観測する基準を重力方向から地球の形に似た楕円体の法線に切り替える必要が出てきた時に、標準時をずらすか本初子午線の位置をずらすか選ぶ必要があり、本初子午線をずらす事に決めたようです。いろいろ調べても「俺が変えた！」という人の話を見つける事は出来なかったので、もしかして誰かが意識的に変えたというよりは、GPS を運用してみてグリニッジ子午線の重力方向が楕円体の法線と結構ズレてる事に気づいたのかも知れません。

![greenwich-move.png](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.amazonaws.com%2F0%2F35350%2Fb36c2092-c7eb-9284-1d2e-54ea38ac62ff.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=84cfcb020255b44371be90da719a7043)

これを図で説明してみます。地球を北極の方向から見下ろした図だと思ってください。今本初子午線であるグリニッジ天文台の真上に太陽が登っているので、ある日これをお昼の 12 時と決めました。ここで自然と「真上」の基準として、水準器で測れる重力の方向を使ってしまったのですが、実はあとから重力の方向は場所によって微妙に異なり(赤い破線)、地球の中心(青い丸)を通っていない事が分かってしまったのです。

その後 GPS による位置の測定が可能になりましたが、緯度や経度の計測には局所的な影響のある水準器ではなく、地球に似た楕円体の中心からの角度を使う(正確には法線を使うので南北方向には中心からズレる)事になりました。

すると困った事が起こりました。地球に似た楕円体の中心から伸びた線 (青の Normal)を「真上」と定義してしまうと、今までのお昼の時刻に太陽が本初子午線の真上に来ないという事になってしまうのです。今までどおり本初子午線の真上に太陽が来た時をお昼と定義するには、今までの子午線を地中の中心を通るように平行移動する必要があります。

こうして決められた新しい本初子午線 (Zero longitude) は古い子午線から 102 メートル東に移動になってしまいましたが、おかげちょうど太陽が真昼に楕円体の法線上に来るようになりました。

本初子午線は世界時や緯度経度を決める非常に大切な基準ですが、全く恣意的な位置のため地球上のどこにあっても構わないはずです。それがグリニッジ天文台の 102 メートル東という微妙な位置に定義されてしまっているのは非常に興味深いです。
