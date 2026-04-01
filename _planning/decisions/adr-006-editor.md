# ADR-006: エディタ/IDE

## ステータス: `decided`

## 背景

現在CursorをメインエディタとしてTypeScript/Node.js開発に使用。VS Codeもインストール済み（Brewfile記載）。2025-2026年はAI IDE競争が激化しており、Windsurf（LogRocketランキング1位）やZed（Rust製・MCP対応）等の新興勢力が台頭。

### 現状（刷新前）
- Cursorがメイン
- VS Codeもインストール済み
- Claude Code CLIの活用度は不明

## 選択肢

### A. Cursor継続 + Claude Code CLI併用
- Cursorの強力なAI機能（Composer、Background Agents）を日常使い
- 複雑なマルチファイル編集・リファクタはClaude Code CLI（100万トークンコンテキスト）
- VS Code拡張エコシステム（50,000+）がそのまま使える
- settings.jsonをchezmoiで管理し、将来の移行性を確保

### B. Windsurf
- Cascade（最も自律的なAIエージェント）、RAGによる自動コンテキスト取得
- Cursorより$5/月安い（$15 vs $20）
- 2025年末にCognition AI（Devin開発元）に買収。将来の方向性が不透明

### C. Zed
- Rust製で圧倒的な速度（0.4秒起動、120FPS、入力遅延2ms）
- MCP対応がネイティブでClaude Code連携が自然
- 拡張機能が約800個。VS Code依存のワークフローには不足

### D. VS Code + Copilot
- Settings Sync + chezmoiの親和性が最高
- Copilot Pro+（$39/月）でClaude Opus 4.6も利用可能
- ただしAI機能はCursorに劣る

## 決定

**A. Cursor継続 + Claude Code CLI併用**

補足方針:
- settings.json、keybindings.json をchezmoiで管理し、将来のエディタ移行に備える
- BrewfileからVS Codeは残す（フォールバック・サブ用途）
- Claude Code CLI をターミナル（cmux）から積極活用し、エディタのAI機能への依存を減らす

## 決定理由

1. **使い慣れたツールの価値** — Cursorに慣れている状態で他に乗り換えるメリットが現時点では限定的。AI IDE領域は半年単位で勢力図が変わるため、今コミットするリスクが高い
2. **Claude Code CLIとの役割分担** — エディタのAI機能に全て依存するのではなく、複雑なタスクはClaude Code CLIに任せることで、エディタ選択の重要性を下げる戦略
3. **移行性の確保** — settings.jsonをchezmoiで管理しておけば、Windsurf/Zed/VS Codeへの移行コストは低い
4. **拡張機能エコシステム** — VS Code互換の50,000+拡張が使えるのは実務上大きい。Zedの800拡張では不足するケースがある

## 備考

エディタ/IDEは他のADRと違い「永続的な決定」ではなく「現時点のベストプラクティス」。半年後に再評価（`revisit`）する価値がある領域。特にWindsurfとZedの動向を注視。

## 日付

2026-03-31
