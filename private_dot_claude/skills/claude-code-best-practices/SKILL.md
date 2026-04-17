---
name: claude-code-best-practices
description: Claude Code公式ベストプラクティスに基づくプロンプト・ワークフロー改善の知識ベース
---

# Claude Code ベストプラクティス知識ベース

cc-advisor サブエージェントがユーザーのプロンプトを分析する際の唯一の基準。
分析観点はここにのみ定義する。cc-advisor.md 側には書かない。

## ソースドキュメント

以下のファイルに公式ドキュメントの内容を保持している。判断に迷ったときはこれらを読んで根拠を確認すること。

- @sources/best-practices.md — プロンプトの書き方、環境設定、セッション管理、スケーリング
- @sources/memory.md — CLAUDE.md の書き方、配置場所、auto memory、トラブルシューティング
- @sources/features-overview.md — CLAUDE.md / スキル / サブエージェント / フック / MCP の使い分け
- @sources/common-workflows.md — コードベース探索、バグ修正、リファクタ、テスト、PR作成等の実践パターン
- @sources/session-management.md — セッション管理、rewind/compact/clear/subagentの使い分け、コンテキストロット

## 更新方法

ソースドキュメントは定期的に更新する。各ファイルの frontmatter に `fetched` 日付がある。
更新するには以下のURLを WebFetch で取得し、ファイルを上書きする:

- https://code.claude.com/docs/en/best-practices
- https://code.claude.com/docs/en/memory
- https://code.claude.com/docs/en/features-overview
- https://code.claude.com/docs/en/common-workflows

---

## チェック観点

プロンプトを受け取ったら、以下の観点で順に分析する。
該当しない観点はスキップしてよい。すべてに言及する必要はない。

### 1. 検証手段を含めているか

Claude は自分で正しさを確認できると劇的に性能が上がる。

確認すること:
- テストケース、期待出力、スクリーンショットなどの検証手段が含まれているか
- 「実装して」で終わっていないか（「実装してテストを実行して」まで含めるべき）
- エラー修正の場合、エラーログや再現手順が添付されているか
- UI変更の場合、スクリーンショット比較を求めているか
- 根本原因の修正を求めているか、それとも症状の抑制になっていないか

根拠: best-practices "Give Claude a way to verify its work" で "the single highest-leverage thing you can do" と明記。検証なしでは Claude の出力が正しく見えても実際には動かないリスクがある。Before/After の例として「"the build is failing" → "the build fails with this error: [paste error]. fix it and verify the build succeeds. address the root cause, don't suppress the error"」が挙げられている。

### 2. プロンプトの情報量は十分か

Claude は意図を推測できるが心は読めない。具体的なほど修正回数が減る。

確認すること:
- 対象のファイル・関数・行番号を `@path/to/file` で参照しているか（@ を使うと Claude がファイルを先に読む）
- 制約条件（使うべきライブラリ、避けるべきパターン等）が明示されているか
- 既存の類似実装を参照しているか（「〇〇のパターンに従って」で一貫性が保たれる）
- エラー修正の場合、具体的なエラーメッセージ・スタックトレース・再現手順があるか
- テキスト以外の入力手段を活用できるか:
  - スクリーンショットの貼り付け（UI変更、エラー画面）
  - `cat error.log | claude` でログをパイプ
  - 外部ドキュメントの URL を提供
  - 画像のドラッグ＆ドロップや ctrl+v

根拠: best-practices "Provide specific context in your prompts" の4つの戦略（スコープを絞る、ソースを指し示す、既存パターンを参照する、症状を具体的に記述する）と "Provide rich content" の入力手段一覧に基づく。"The more precise your instructions, the fewer corrections you'll need."

### 3. タスクの進め方は適切か

いきなりコードを書かせると間違った問題を解くリスクがある。タスクの性質に応じた進め方がある。

確認すること:
- 複数ファイルにまたがる、アプローチが不確実、不慣れなコードを変更する → Plan Mode（Shift+Tab）で探索・計画してから実装を推奨
- 仕様が曖昧で技術的な判断ポイントが複数ある → インタビュー手法（「AskUserQuestionツールで詳しくインタビューして。全部カバーしたらSPEC.mdに書いて」）を提案。スペック完成後は新しいセッションで実装すると、クリーンなコンテキストで取り組める
- バグ修正 → 再現コマンド＋エラーログ＋「再現テストを書いてから修正」のパターンが効果的
- リファクタ → 「同じ振る舞いを維持しつつ」の制約＋テスト実行で検証
- テスト追加 → エッジケースの指定＋既存テストのパターンに合わせる指示

スキップしてよい場合: タイポ修正、ログ追加、変数リネームなど、1文で diff を説明できるシンプルなタスク。

根拠: best-practices "Explore first, then plan, then code" で4フェーズのワークフロー（Explore → Plan → Implement → Commit）が推奨されている。"Planning is most useful when you're uncertain about the approach, when the change modifies multiple files, or when you're unfamiliar with the code being modified. If you could describe the diff in one sentence, skip the plan." また "Let Claude interview you" でインタビュー手法が説明されている。common-workflows にタスク種別ごとの具体的な進め方がある。

### 4. コンテキストは適切に管理されているか

コンテキストウィンドウは Claude Code で最も重要なリソース。埋まるにつれ性能が劣化する。

確認すること:
- 前のタスクと無関係な新しいタスクを始めようとしていないか → `/clear` してから始めることを推奨
- 同じ問題で修正を2回以上繰り返していないか → `/clear` して学んだことを反映した新しいプロンプトで再スタート
- 広範な調査（多数のファイルを読む）をメインセッションで直接やろうとしていないか → 「サブエージェントで〇〇を調査して」に委任を提案
- 本題に関係ない軽い質問か → `/btw` を使えばコンテキストを消費せずに回答を得られる

根拠: best-practices の冒頭で "Most best practices are based on one constraint: Claude's context window fills up fast, and performance degrades as it fills." と明記。"Avoid common failure patterns" で5つの失敗パターンが挙げられている:
- kitchen sink session（無関係なタスクの混在）→ /clear
- correcting over and over（同じ修正の繰り返し）→ /clear して再スタート
- infinite exploration（スコープなしの調査）→ サブエージェント
- trust-then-verify gap（検証なしの信頼）→ 検証を必ず含める
- over-specified CLAUDE.md（肥大化）→ 剪定
"A clean session with a better prompt almost always outperforms a long session with accumulated corrections."

### 5. 繰り返しパターンを永続化すべきか

同じ指示や作業の繰り返しは、適切な仕組みで永続化すべき。使い分けの判断基準が公式に定義されている。

確認すること:
- 同じ修正・指示を2回以上伝えていないか → CLAUDE.md に追記（memory.md: "Claude makes the same mistake a second time"）
- 同じプロンプトを繰り返し打っていないか → スキル（.claude/skills/）として定義
- 同じ手順書を3回以上チャットに貼っていないか → スキルに変換
- 外部サービスのデータを毎回手動でコピーしていないか → MCP サーバーを接続
- サイドタスクがメインコンテキストを汚染していないか → サブエージェント（.claude/agents/）に切り出し
- 毎回例外なく実行すべき処理があるか → フック（hooks）で自動化
- 同じセットアップを別リポジトリでも使うか → プラグインとしてパッケージ化

CLAUDE.md に関する注意:
- 200行以下を目標。肥大化すると Claude が指示を無視する（"Bloated CLAUDE.md files cause Claude to ignore your actual instructions!"）
- コードを読めばわかること、一般的な慣習、頻繁に変わる情報は書かない
- 複数ファイルのルールに矛盾があると Claude が任意に選ぶ
- 特定のファイルパスにだけ適用するルールは .claude/rules/ に paths 付きで配置

根拠: features-overview "Build your setup over time" の表にトリガーと追加すべき機能の対応が明記されている。memory.md "When to add to CLAUDE.md" に追記すべきタイミングの判断基準がある。features-overview の比較表（CLAUDE.md vs Skill, CLAUDE.md vs Rules vs Skills, Skill vs Subagent, MCP vs Skill）に使い分けの根拠がある。

### 6. セッションのライフサイクルを適切に管理しているか

Claude のターンが終わるたびに「次にどうするか」の判断ポイントがある。continue 以外にも rewind / clear / compact / subagent の選択肢があり、状況に応じて使い分けるとコンテキストの質を保てる。

確認すること:
- 失敗したアプローチを修正メッセージで上書きしようとしていないか → **rewind**（`esc esc`）でファイル読み込み直後まで戻り、学んだことを含めて再プロンプトする方が効果的。失敗した試行のコンテキストがノイズとして残らない
- 長いセッションでコンテキストが膨らんでいないか → ~300-400k トークン付近からコンテキストロット（性能劣化）が始まる。autocompact に任せず、**proactive に `/compact` を実行**し、次にやることの説明を添える（例: `/compact focus on the auth refactor, drop the test debugging`）
- compact と clear の使い分け:
  - `/compact` — 自分で何も書かなくてよい。Claude が網羅的に要約する。ただしロッシー（何を残すかは Claude 判断）
  - `/clear` — 手間がかかるが、何が関連するかを自分で決められる。精度が必要な場面向き
- 中間出力が大量に出るが結論だけ必要な作業をメインセッションでやろうとしていないか → **サブエージェント**に委任。判断基準:「このツール出力にまた必要になるか、それとも結論だけでよいか？」
- 関連タスクを続けるか新セッションにするかの判断 → ファイル再読み込みのコスト vs コンテキスト劣化のコストを天秤にかける。知能が強く求められないタスク（ドキュメント作成等）なら既存セッション継続もあり

根拠: session-management.md に基づく。コンテキストロットは ~300-400k トークン付近から観察される（タスク依存）。bad compact の主因は「コンテキストロットで知能が最も低い時点で要約が走る」こと。rewind は "the single habit that signals good context management" と評されている。サブエージェントの判断基準は「中間出力にまた必要になるか、結論だけでよいか」。
