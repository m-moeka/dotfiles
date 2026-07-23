---
source: https://platform.claude.com/docs/ja/build-with-claude/prompt-engineering/claude-prompting-best-practices
fetched: 2026-07-23
title: プロンプティングのベストプラクティス（全モデル共通）
note: API専用のSDKコードサンプルは省略。プロンプト例文はすべて保持。
---

# プロンプティングのベストプラクティス

Claude Fable 5、Claude Mythos 5、Claude Opus 4.8/4.7/4.6、Claude Sonnet 5/4.6、Claude Haiku 4.5 を含む最新モデルでのプロンプトエンジニアリングのリファレンス。

モデル固有のガイダンスは専用ページ（prompting-claude-fable-5.md / prompting-claude-sonnet-5.md / prompting-claude-opus-4-8.md）を参照。

## 一般原則

### 明確かつ直接的に

Claudeは明確で明示的な指示によく応答する。望む出力について具体的に指定すること。「期待以上」の振る舞いを望む場合は、曖昧なプロンプトからの推測に頼らず、明示的に要求する。

Claudeを「あなたの規範やワークフローに関するコンテキストを持たない、優秀だが新しい従業員」と考える。

**黄金律：** タスクに関する最小限のコンテキストしか持たない同僚にプロンプトを見せて従ってもらえるか。その人が混乱するならClaudeも混乱する。

- 望む出力フォーマットと制約について具体的に指定する
- ステップの順序や完全性が重要な場合は、番号付きリストで順次的なステップとして提供する

例：
- 効果が低い: `Create an analytics dashboard`
- より効果的: `Create an analytics dashboard. Include as many relevant features and interactions as possible. Go beyond the basics to create a fully-featured implementation.`

### コンテキスト（理由・動機）を追加する

指示の背後にあるコンテキストや動機（なぜその振る舞いが重要なのか）を説明すると、Claudeは目標をよりよく理解し、的を絞った応答ができる。Claudeは説明から一般化できる。

例：
- 効果が低い: `NEVER use ellipses`
- より効果的: `Your response will be read aloud by a text-to-speech engine, so never use ellipses since the text-to-speech engine will not know how to pronounce them.`

### 例を効果的に使用する

例（few-shot / multishot）は出力フォーマット、トーン、構造を誘導する最も信頼性の高い方法の1つ。

- **関連性がある**: 実際のユースケースを忠実に反映する
- **多様である**: エッジケースをカバーし、意図しないパターンを拾わせない
- **構造化されている**: `<example>` タグ（複数は `<examples>`）で囲む

最良の結果を得るには3〜5個の例を含める。

### XMLタグでプロンプトを構造化する

指示・コンテキスト・例・変数入力が混在する場合、`<instructions>`, `<context>`, `<input>` などのタグで囲むと誤解釈が減る。

- 一貫性のある説明的なタグ名を使う
- 自然な階層がある場合はネストする

### Claudeに役割を与える

システムプロンプトで役割を設定すると振る舞いとトーンが絞り込まれる。1文でも違いが生まれる。

### 長いコンテキストのプロンプティング

大きなドキュメント（20kトークン以上）を扱う場合：

- **長文データを先頭に置く**: クエリや指示より上に配置。クエリを末尾に置くと応答品質が最大30%向上することがある
- **XMLタグでドキュメントと メタデータを構造化する**: `<document>` + `<document_content>` + `<source>` サブタグ
- **引用に基づいて応答させる**: タスク実行前にドキュメントの関連部分を引用させる（`<quotes>` タグ等）と関連コンテンツに集中できる

## 出力とフォーマット

### コミュニケーションスタイルと冗長性

最新モデルは以前より簡潔で自然なコミュニケーションスタイルを持つ。より直接的・事実ベースで、冗長性が低い。ツール呼び出し後の要約を省略することがあるため、可視性を高めたい場合：

```
After completing a task that involves tool use, provide a quick summary of the work you've done.
```

### 応答のフォーマットを制御する

1. **してはいけないことではなく、すべきことを伝える**（「markdownを使わないで」→「滑らかに流れる散文の段落で構成して」）
2. **XMLフォーマットインジケーターを使用する**
3. **プロンプトのスタイルを望む出力に合わせる**（プロンプトからmarkdownを削ると出力のmarkdownも減る）
4. **特定のフォーマットの好みには詳細なプロンプトを使用する**

### 事前入力（prefill）からの移行

Claude 4.6以降、最後のアシスタントターンでのprefillは非サポート（400エラー）。代替: 構造化出力、直接的な指示（「前置きなしで直接応答」）、ユーザーメッセージでの継続指示。

## ツール使用

### ツールの使い方

最新モデルは正確な指示遵守のために訓練されており、**アクションを求めるなら明示的に指示する**ことで効果が高まる。「いくつか変更を提案してもらえますか」と言うと、実装ではなく提案だけを返すことがある。

- 効果が低い（提案のみ）: `Can you suggest some changes to improve this function?`
- より効果的（変更を実行）: `Change this function to improve its performance.`

デフォルトで積極的に行動させたい場合のシステムプロンプト例：

```
<default_to_action>
By default, implement changes rather than only suggesting them. If the user's intent is
unclear, infer the most useful likely action and proceed, using tools to discover any
missing details instead of guessing.
</default_to_action>
```

逆に慎重にさせたい場合：

```
<do_not_act_before_instructions>
Do not jump into implementation or change files unless clearly instructed to make
changes. When the user's intent is ambiguous, default to providing information, doing
research, and providing recommendations rather than taking action.
</do_not_act_before_instructions>
```

**重要:** 最新モデル（Opus 4.5以降）はシステムプロンプトへの反応性が高い。「CRITICAL: You MUST use this tool when...」のような強い表現は過剰トリガーを引き起こす。「Use this tool when...」のような通常の表現で十分。

### 並列ツール呼び出し

最新モデルは独立したツール呼び出しを並列実行する（複数ファイルの同時読み込み、投機的検索、bashの並列実行）。プロンプトで約100%に引き上げることも、逆に抑えることもできる。

## 思考と推論

### 過剰な思考と過度な徹底性

高いeffort設定では、指示されなくても広範なコンテキスト収集や複数のリサーチをすることがある。旧モデル向けに「徹底的にやれ」と促すプロンプトは調整が必要：

- 包括的なデフォルトを的を絞った指示に置き換える（「デフォルトで[tool]を使用」→「問題の理解に役立つ場合は[tool]を使用」）
- 過剰なプロンプティングを削除する（「迷ったら[tool]を使用」は過剰トリガーの原因）

思考を制約する例：

```
When you're deciding how to approach a problem, choose an approach and commit to it.
Avoid revisiting decisions unless you encounter new information that directly
contradicts your reasoning.
```

### 思考の誘導

- **規範的なステップよりも一般的な指示を優先する**: 「徹底的に考えてください」のようなプロンプトは、手書きのステップバイステップの計画よりも優れた推論を生むことが多い
- **マルチショットの例は思考と併用できる**: few-shot例の中で `<thinking>` タグで推論パターンを示せる
- **自己チェックを依頼する**: 「終了する前に[テスト基準]に対して回答を検証してください」はコーディングと数学で特に有効

## エージェントシステム

### 長期タスクと状態管理

- 状態データには構造化フォーマット（JSON）、進捗メモには非構造化テキスト
- 状態追跡にgitを使用する（最新モデルはgitでのセッション横断の状態追跡に優れる）
- 漸進的な進捗を強調する
- コンテキストウィンドウをまたぐタスクでは、コンパクションより新規セッション + ローカルファイルからの状態復元が有効な場合がある

### 自律性と安全性のバランス

ガイダンスがないと、元に戻すのが難しいアクション（ファイル削除、強制プッシュ、外部サービスへの投稿）を取ることがある。リスクのあるアクション前に確認させるプロンプト例：

```
Consider the reversibility and potential impact of your actions. You are encouraged to
take local, reversible actions like editing files or running tests, but for actions that
are hard to reverse, affect shared systems, or could be destructive, ask the user before
proceeding.
```

### リサーチと情報収集

1. 明確な成功基準を提供する
2. ソースの検証を促す（複数ソースでの検証）
3. 複雑なリサーチには構造化アプローチ（競合仮説の追跡、信頼度の記録、自己批判）

### サブエージェントのオーケストレーション

最新モデルはサブエージェントをネイティブにオーケストレーションする。過剰使用が見られる場合：

```
Use subagents when tasks can run in parallel, require isolated context, or involve
independent workstreams that don't need to share state. For simple tasks, sequential
operations, single-file edits, or tasks where you need to maintain context across steps,
work directly rather than delegating.
```

### 過剰な積極性（オーバーエンジニアリング）

余分なファイル作成、不要な抽象化、要求されていない柔軟性の組み込みが見られる場合：

```
Avoid over-engineering. Only make changes that are directly requested or clearly
necessary. Keep solutions simple and focused:
- Scope: Don't add features, refactor code, or make "improvements" beyond what was asked.
- Documentation: Don't add docstrings, comments, or type annotations to code you didn't change.
- Defensive coding: Don't add error handling, fallbacks, or validation for scenarios that can't happen. Only validate at system boundaries.
- Abstractions: Don't create helpers, utilities, or abstractions for one-time operations. The right amount of complexity is the minimum needed for the current task.
```

### テスト合格へのハードコーディングを避ける

```
Implement a solution that works correctly for all valid inputs, not just the test cases.
Do not hard-code values or create solutions that only work for specific test inputs.
Tests are there to verify correctness, not to define the solution.
If the task is unreasonable or infeasible, or if any of the tests are incorrect, please
inform me rather than working around them.
```

### ハルシネーションの最小化

```
<investigate_before_answering>
Never speculate about code you have not opened. If the user references a specific file,
you MUST read the file before answering. Make sure to investigate and read relevant
files BEFORE answering questions about the codebase.
</investigate_before_answering>
```

## 移行時の考慮事項（旧世代→現行モデル）

1. 望む振る舞いについて具体的に指定する
2. 修飾語で出力の品質と詳細を高める（「ダッシュボードを作って」→「...関連する機能とインタラクションをできるだけ多く含めて」）
3. アニメーションやインタラクティブ要素は明示的に要求する
4. 怠惰防止のプロンプティングを控えめにする（現行モデルは積極的で、旧モデル向けの指示に過剰反応する）
