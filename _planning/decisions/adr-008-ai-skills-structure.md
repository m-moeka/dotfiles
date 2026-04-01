# ADR-008: AI skills/hooks/commandsの構成

## ステータス: `decided`

## 背景

Claude Code、Cursor等の複数AIツールに「指示書」を書く必要がある。ツールごとに異なるファイル名（CLAUDE.md, .cursorrules等）で重複管理するのは非効率。

## 決定

**AGENTS.md を単一ソース・オブ・トゥルースとして採用する**

### 構成
- プロジェクトルートに `AGENTS.md` を1つ置く（Linux Foundation傘下の標準規格）
- Claude Code, Cursor, Copilot, Windsurf, Zed等の主要ツールが全て読める
- ツール固有の機能が必要な場合のみ `CLAUDE.md` や `.cursorrules` を追加

### グローバルのskills/hooks/commands
- `~/.claude/skills/` にスキル定義を配置（chezmoiで管理: ADR-007）
- `~/.claude/commands/` にスラッシュコマンドを配置
- Hooksはプロジェクトの `.claude/settings.json` で定義

## 決定理由

1. AGENTS.mdは60,000+リポジトリで採用されている実績ある標準規格
2. 1ファイルで複数ツール対応。重複管理の手間がなくなる
3. ツール固有機能は追加ファイルで対応可能なので柔軟性も確保

## 日付

2026-03-31
