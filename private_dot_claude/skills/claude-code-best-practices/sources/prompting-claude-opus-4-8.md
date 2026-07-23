---
source: https://platform.claude.com/docs/ja/build-with-claude/prompt-engineering/prompting-claude-opus-4-8
fetched: 2026-07-23
title: Claude Opus 4.8のプロンプティング
note: API専用のeffort/computer use詳細は要点のみ。
---

# Claude Opus 4.8のプロンプティング

Claude Opus 4.8は長期的なエージェント作業、ナレッジワーク、ビジョン、メモリタスクに特に強い。既存のOpus 4.7のプロンプトでもそのまま良好に動作する。

## 応答の長さと冗長性

固定された冗長性ではなく、タスクの複雑さに応じて応答の長さを調整する（単純な検索には短く、自由度の高い分析には長く）。冗長性を減らすには：

```
Provide concise, focused responses. Skip non-essential context, and keep examples minimal.
```

**ポジティブな例（適切な簡潔さの見本を示す）は、ネガティブな例や禁止指示より効果的。**

## effortと思考の深さ（API向け要点）

- コーディング・エージェント用途は `xhigh` から開始、知能が重要な用途は最低 `high`
- effortレベルを厳密に尊重する。`low`/`medium` では求められた範囲に作業をスコープする
- 複雑な問題で浅い推論が見られたら、プロンプトで回避せず effort を上げるのが第一のレバー
- 思考はデフォルトオフ（`thinking: {type: "adaptive"}` で有効化）

## ツール使用のトリガー

ツール呼び出しよりも推論を優先する傾向がある（ほとんどの場合より良い結果）。ツール使用を増やしたい場合は、effortを上げるか、いつ・なぜ・どのようにツールを使うべきかを明示的に指示する。

## ユーザー向けの進捗更新

長いエージェント的なトレース全体を通じて、定期的で質の高い更新を自然に提供する。**中間ステータスメッセージを強制するスキャフォールディング（「ツール呼び出し3回ごとに進捗を要約する」）は削除を試す。**

## より字義通りの指示追従

プロンプトを字義通りかつ明示的に解釈する（特に低effort）。ある項目への指示を別の項目に暗黙的に一般化しない。利点は精度と予測可能性。**指示を広く適用させたい場合はスコープを明示する**（「このフォーマットを最初のセクションだけでなく、すべてのセクションに適用してください」）。

## トーンと文体

肯定的な相槌を最小限に抑え、絵文字を控えめに使う、直接的で意見のはっきりしたスタイルを好む。特定のボイスが必要なら明示：

```
Use a warm, collaborative tone. Acknowledge the user's framing before answering.
```

## サブエージェントの生成の制御

デフォルトではより少ないサブエージェントを生成する傾向。望ましい場合を明示的にガイドする：

```
Do not spawn a subagent for work you can complete directly in a single response.
Spawn multiple subagents in the same turn when fanning out across items or reading
multiple files.
```

## デザインとフロントエンドのデフォルト

強いデザインの直感と一貫したハウススタイル（クリーム/オフホワイト背景 約#F4F1EA、セリフのディスプレイ書体、テラコッタ/アンバーのアクセント）を持つ。ダッシュボード・開発ツール・フィンテック等には違和感がある。

一般的な指示（「クリーム色を使わないで」）は別の固定パレットに移るだけ。確実なアプローチは2つ：

1. **具体的な代替案を指定する**（色コード、書体、コーナー半径まで明示すると正確に従う）
2. **構築前に選択肢を提案させる**：

```
Before building, propose 4 distinct visual directions tailored to this brief (each as:
bg hex / accent hex / typeface — one-line rationale). Ask the user to pick one, then
implement only that direction.
```

「AI slop」回避のプロンプティングは以前のモデルより少なくて済む。短いスニペットで十分：

```
<frontend_aesthetics>
NEVER use generic AI-generated aesthetics like overused font families (Inter, Roboto,
Arial, system fonts), cliched color schemes (particularly purple gradients), predictable
layouts, and cookie-cutter design that lacks context-specific character.
</frontend_aesthetics>
```

## インタラクティブなコーディングプロダクト

インタラクティブな設定ではユーザーターン後により多くの推論を行い、トークン使用量が増える。パフォーマンスとトークン効率の両方を最大化するには：

- **最初のターンでタスク・意図・関連する制約を事前に指定する**ことが重要
- 曖昧・仕様不足のプロンプトを複数ターンで段階的に伝えると、トークン効率もパフォーマンスも低下する傾向

## コードレビューハーネス

バグ発見能力は以前のモデルより大幅に向上（再現率・適合率とも）。ただし「重大度の高い問題のみ報告」「保守的に」などの指示に**以前のモデルより忠実に従う**ため、発見を報告しないことがあり、測定上の再現率が低く見えることがある。

網羅性を求める場合の推奨文言：

```
Report every issue you find, including ones you are uncertain about or consider
low-severity. Do not filter for importance or confidence at this stage - a separate
verification step will do that. Your goal here is coverage. For each finding, include
your confidence level and an estimated severity so a downstream filter can rank them.
```

単一パスで自己フィルタリングさせる場合は「重要」のような定性的な用語ではなく基準を具体的に示す（「不正な動作、テストの失敗、誤解を招く結果を引き起こす可能性のあるバグを報告。純粋なスタイルや命名の好みのみ省略」）。
