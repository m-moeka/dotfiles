# ADR-007: Claude Code設定の管理方針

## ステータス: `decided`

## 背景

Claude Code CLIの設定（`~/.claude/`）をdotfilesとしてchezmoiで管理し、マシン間で同期する方針を決める。

## 決定

**`~/.claude/` をchezmoiで管理する**

### 管理対象
- `~/.claude/CLAUDE.md` — グローバル指示書
- `~/.claude/commands/` — カスタムスラッシュコマンド
- `~/.claude/skills/` — スキル定義（SKILL.md）
- `~/.claude/settings.json` — ユーザー設定

### 管理対象外（gitignore）
- `~/.claude.json` — OAuthトークン、MCP設定キャッシュ
- `~/.claude/projects/` — 会話履歴
- `~/.claude/file-history/` — 編集履歴スナップショット
- `.claude/settings.local.json` — プロジェクト別ローカル設定

## 決定理由

chezmoiで管理することで、新しいMacでも `chezmoi init --apply` 一発で自分のClaude Code環境が再現される。シークレットは含まれないファイルのみ管理対象とし、安全に公開リポジトリに置ける。

## 日付

2026-03-31
