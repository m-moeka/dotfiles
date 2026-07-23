---
source: https://platform.claude.com/docs/ja/build-with-claude/prompt-engineering/prompting-claude-sonnet-5
fetched: 2026-07-23
title: Claude Sonnet 5のプロンプティング
note: API専用のeffort/tokenizer/computer use詳細は要点のみ。
---

# Claude Sonnet 5のプロンプティング

Claude Sonnet 5はコーディングとエージェント的なタスクに特に強い。既存のSonnet 4.6のプロンプトでもそのまま良好に動作する。

## 応答の長さと冗長性

固定された冗長性ではなく、タスクの複雑さに応じて応答の長さを調整する。冗長性を減らすには：

```
Provide concise, focused responses. Skip non-essential context, and keep examples minimal.
```

**ポジティブな例（適切な簡潔さの見本を示す）は、ネガティブな例や禁止指示より効果的。**

## effortと思考の深さ（API向け要点）

- デフォルトは `high`。最も難しいコーディング・エージェントタスクには `xhigh`
- 目安: Sonnet 5のmedium ≒ Sonnet 4.6のhigh、Sonnet 5のhigh ≒ Sonnet 4.6のmax
- effortレベルを厳密に尊重する。`low`/`medium` では求められた範囲に作業をスコープする
- 適応的思考がデフォルトで有効（Sonnet 4.6からの変更点）
- 複雑な問題で浅い推論が見られたら、プロンプトで回避せずeffortを上げるのが第一のレバー

## ツール使用のトリガー

デフォルトでSonnet 4.6よりエージェント的で、ツールに手を伸ばしたり自己検証ループを実行したりすることが積極的。思考を無効にするとツールに手を伸ばす可能性が下がる。ツール使用を増やしたいなら、いつ・なぜ・どのように使うべきかを明示的に指示する。

## ユーザー向けの進捗更新

長いエージェント的なトレース全体を通じて、定期的で高品質な更新を自然に提供する。**中間ステータスメッセージを強制するスキャフォールディングは削除を試す。**

## より文字通りの指示追従

プロンプトを文字通りかつ明示的に解釈する（特に低effort）。ある項目への指示を別の項目に暗黙的に一般化せず、行っていない要求を推測しない。**指示を広く適用させたい場合はスコープを明示する**（「このフォーマットを最初のセクションだけでなく、すべてのセクションに適用してください」）。

## トーンと文体

特定のボイスが必要なら明示的にスタイルプロンプトを与える。`temperature`/`top_p`/`top_k` は非デフォルト値で400エラー（Sonnetクラスでは新しい制約）— スタイルの多様性はプロンプト指示で導く。

## デザインとフロントエンドのデフォルト

自由度の高いブリーフに対して一貫したデフォルトのビジュアルスタイルに落ち着くことがある。一般的な指示（「その色を使わないで」）は別の固定パレットに移るだけ。確実なアプローチは2つ：

1. **具体的な代替案を指定する**（明示的な仕様には正確に従う）
2. **構築前に選択肢を提案させる**（temperatureが使えないため、実行ごとに異なる方向性を得る推奨手段）：

```
Before building, propose 4 distinct visual directions tailored to this brief (each as:
bg hex / accent hex / typeface, plus a one-line rationale). Ask the user to pick one,
then implement only that direction.
```

「AI slop」回避の短いスニペット：

```
<frontend_aesthetics>
NEVER use generic AI-generated aesthetics like overused font families (Inter, Roboto,
Arial, system fonts), cliched color schemes (particularly purple gradients), predictable
layouts, and cookie-cutter design that lacks context-specific character.
</frontend_aesthetics>
```

## インタラクティブなコーディングプロダクト

パフォーマンスとトークン効率の両方を最大化するには：

- **最初のターンでタスク・意図・関連する制約を事前に指定する**ことが重要
- 曖昧・仕様不足のプロンプトを複数ターンで段階的に伝えると、トークン効率もパフォーマンスも低下する傾向

## コードレビューハーネス

「重大度の高い問題のみ報告」「保守的に」などの指示に**以前のモデルより忠実に従う**ため、コードを同じ深さで調査してもバグを報告しないことがあり、測定上の再現率が低く見えることがある（能力の後退ではない）。

網羅性を求める場合の推奨文言：

```
Report every issue you find, including ones you are uncertain about or consider
low-severity. Do not filter for importance or confidence at this stage - a separate
verification step will do that. Your goal here is coverage. For each finding, include
your confidence level and an estimated severity so a downstream filter can rank them.
```

単一パスで自己フィルタリングさせる場合は「重要」のような定性的な用語ではなく基準を具体的に示す。
