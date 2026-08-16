# ADR-008: AI skills/hooks/commandsの構成

## ステータス: `decided`

## 背景

Claude Code、Cursor等の複数AIツールに「指示書」を書く必要がある。ツールごとに異なるファイル名（CLAUDE.md, .cursorrules等）で重複管理するのは非効率。

## 決定

**`~/.agents`を共通の指示とskillsの単一ソースとして採用する**

### 構成

- グローバル指示は`~/.agents/AGENTS.md`で管理する
- Codexは`~/.codex/AGENTS.md`から共通ファイルをsymlinkで参照する
- Claude Codeは`~/.claude/CLAUDE.md`から共通ファイルをimportする
- プロジェクト固有の指示には、各リポジトリの`AGENTS.md`を使う
- ツール固有の指示が必要な場合のみ`CLAUDE.md`などを追加する

### グローバルのskills/hooks/commands

- 共通skillsは`~/.agents/skills/`で管理する
- Claude Codeは`~/.claude/skills/`のsymlinkから共通skillsを参照する
- Codexは`~/.agents/skills/`をネイティブに検出する
- ツール固有のskills、hooks、commandsは各ツールのディレクトリに残す

## 決定理由

1. 共通指示とskillsの重複をなくし、Claude CodeとCodexで同じ内容を利用できる
2. ツール固有機能は各ツールのディレクトリに残せる
3. `~/.agents`はCodexの標準探索先として利用できる

## 日付

2026-03-31

## 改訂

2026-08-16：Claude CodeとCodexの共通化に合わせ、グローバル構成を`~/.agents`中心へ変更した。
