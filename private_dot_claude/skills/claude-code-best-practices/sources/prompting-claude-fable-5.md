---
source: https://platform.claude.com/docs/ja/build-with-claude/prompt-engineering/prompting-claude-fable-5
fetched: 2026-07-23
title: Claude Fable 5のプロンプティング
---

# Claude Fable 5のプロンプティング

Claude Fable 5とClaude Mythos 5に固有のプロンプティングとスキャフォールディングのパターン。

Claude Fable 5は、従来のモデルでは複雑すぎたり、長時間かかりすぎたり、曖昧すぎたりした問題に取り組むことができ、人が完了するのに数時間〜数週間かかるエンドツーエンドの作業に特に効果的。単純なワークロードのみでテストすると能力の幅を過小評価しがち。

## 能力の向上（Opus 4.8比）

- **長期的な自律性**: 数日にわたる目標指向の実行を、強力な指示の保持を保ちながら完了
- **複雑で明確に仕様化された問題に対する初回の正確性**: 以前は数日の反復を要したシステムを一度の実行で実装できた報告あり
- **ビジョン**: 密度の高い技術的画像・スクリーンショットを高精度で解釈。反転・ぼやけ・ノイズ画像にbashやクロップツールを使うよう訓練済み
- **エンタープライズワークフロー**: 指示に従い、スコープ内にとどまる
- **コードレビューとデバッグ**: バグ発見の再現率がOpus 4.8より顕著に高い
- **曖昧さへの対応**: 複雑でマルチスレッドなリクエストから次のステップを決定するのが得意
- **委任とコラボレーション**: 並列サブエージェントのディスパッチと維持の信頼性が大幅に向上

注意: 攻撃的サイバーセキュリティ・生物学/ライフサイエンス・思考抽出を対象とする安全性分類器が動く。無害な作業もトリガーする可能性がある（`stop_reason: "refusal"`）。

## デフォルトでより長いターン

困難なタスクへの個々のリクエストは高effortで数分間実行されることがあり、自律実行は数時間に及ぶことも。曖昧なタスクで過剰に計画を立てないようにするには：

```
When you have enough information to act, act. Do not re-derive facts already established
in the conversation, re-litigate a decision the user has already made, or narrate
options you will not pursue in user-facing messages. If you are weighing a choice, give
a recommendation, not an exhaustive survey.
```

## 強力な指示追従

指示追従が十分に改善されているため、**各動作を列挙するのではなく、簡潔な指示でほとんどの動作を制御できる**。高effortではタスクに必要な範囲を超えて詳述する傾向（追求しない選択肢の調査、根本原因の長い説明、過度に構造化されたPR説明）があるが、短い簡潔さの指示で足りる：

```
Lead with the outcome. Your first sentence after finishing should answer "what happened"
or "what did you find". Supporting detail and reasoning come after. Being readable and
being concise are different things, and readability matters more.
```

チェックポイント動作も同様に、ケースの列挙は不要：

```
Pause for the user only when the work genuinely requires them: a destructive or
irreversible action, a real scope change, or input that only they can provide.
```

## 長時間実行中の進捗報告を根拠に基づかせる

実際のツール結果に照らして進捗を監査するよう指示すると、捏造されたステータスレポートがほぼ排除される：

```
Before reporting progress, audit each claim against a tool result from this session.
Only report work you can point to evidence for; if something is not yet verified, say so
explicitly.
```

## 境界を明示する

要求されていないアクション（依頼されていないメールの下書き、防御的なgitブランチのバックアップ作成など）を時折実行することがある。行うべき／行うべきでないことの明示的な制約を定義する：

```
When the user is describing a problem, asking a question, or thinking out loud rather
than requesting a change, the deliverable is your assessment. Report your findings and
stop. Don't apply a fix until they ask for one.
```

## 並列サブエージェント

従来のモデルより積極的に並列サブエージェントをディスパッチする。委任が適切なタイミングの明示的なガイダンスを提供し、ブロックするのではなく非同期通信を優先する：

```
Delegate independent subtasks to subagents and keep working while they run. Intervene if
a subagent goes off track or is missing relevant context.
```

## メモリシステムを構築する

以前の実行から得た教訓を記録・参照できる場合に特に優れたパフォーマンスを発揮する。Markdownファイルのようなシンプルなもので十分：

```
Store one lesson per file with a one-line summary at the top. Record corrections and
confirmed approaches alike, including why they mattered. Don't save what the repo or
chat history already records; update an existing note rather than creating a duplicate.
```

## まれに発生する早期停止

長いセッションの深い段階で、ツール呼び出しなしのテキストのみの意図表明（「これからXを実行します」）でターンを終えたり、十分な情報があるのに許可を求めたりすることがまれにある。「続けて」で十分。自律パイプラインの場合：

```
You are operating autonomously. The user is not watching in real time and cannot answer
questions mid-task. For reversible actions that follow from the original request,
proceed without asking. Before ending your turn, check your last paragraph. If it is a
plan, a question, or a promise about work you have not done, do that work now with tool
calls.
```

## まれに発生するコンテキストバジェットへの懸念

非常に長いセッションで、新セッションの提案や作業の削減をすることがまれにある。残りトークンのカウントダウン表示が主なトリガー。必要なら：

```
You have ample context remaining. Do not stop, summarize, or suggest a new session on
account of context limits. Continue the work.
```

## リクエストだけでなく理由も伝える

リクエストの背後にある意図を理解している場合により優れたパフォーマンスを発揮する：

```
I'm working on [the larger task] for [who it's for]. They need [what the output
enables]. With that in mind: [request].
```

## ユーザーとのコミュニケーションにおける読みやすさ

長いエージェント的な会話で、理解しにくいテキスト（矢印チェーン省略表記、深い実装詳細、ユーザーが見ていない思考への言及）を生成することがある。補足指示で軽減：

```
When you write the summary at the end, drop the working shorthand. Write complete
sentences. Spell out terms. Don't use arrow chains, hyphen-stacked compounds, or labels
you made up earlier. Open with the outcome. If you have to choose between short and
clear, choose clear.
```

## send-to-userツール（API/ハーネス構築者向け）

長時間の非同期エージェントには、ターンを終了せずにユーザーへ逐語的にメッセージを届けるツールを与える。ツール定義だけでは呼ばれない — システムプロンプトの誘導文言が必要。

## 推奨されるスキャフォールディングの変更

- **難易度範囲の上限から始める**: 従来モデルより難しいタスクを選び、スコープ定義・明確化質問・実行までさせる
- **長時間実行のプロンプトで自己検証を明示的にする**: 独立した新しいコンテキストを持つ検証用サブエージェントは自己批判より優れる
- **既存のプロンプトとスキルをリファクタリングする**: 従来モデル向けに開発されたスキルは**Fable 5にとって規範的すぎることが多く、出力品質を低下させる可能性がある**。デフォルトのパフォーマンスの方が優れている場合は古い指示の削除を検討
- **推論を応答内で再現するよう指示しない**: 内部推論のエコー・転記・説明を求める指示は `reasoning_extraction` 拒否カテゴリをトリガーする。既存のスキルとシステムプロンプトを監査すること
