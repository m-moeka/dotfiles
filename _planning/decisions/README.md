# Dotfiles Renewal: Decision Log

dotfilesをAIファーストなスタックに刷新するにあたり、意思決定が必要な項目を管理する。

## ステータス凡例

| ステータス | 意味 |
|-----------|------|
| `pending` | 未着手 - まだ議論していない |
| `discussing` | 議論中 - 深掘り・比較検討中 |
| `decided` | 決定済み |
| `revisit` | 再検討が必要 |

---

## Decision Map

### Layer 1: 基盤（最初に決めるべき）

| # | 決定事項 | ステータス | 結論 | 詳細 |
|---|---------|-----------|------|------|
| 001 | dotfiles管理ツール | `decided` | **chezmoi** | [ADR-001](./adr-001-dotfiles-manager.md) |
| 002 | ターミナルエミュレータ | `decided` | **cmux**（フォールバック: Ghostty） | [ADR-002](./adr-002-terminal-emulator.md) |
| 003 | シェル（zsh / fish / bash） | `decided` | **zshモダン化**（Zinit + Starship） | [ADR-003](./adr-003-shell.md) |

### Layer 2: 開発ツールチェーン

| # | 決定事項 | ステータス | 結論 | 詳細 |
|---|---------|-----------|------|------|
| 004 | バージョンマネージャ（mise / asdf / nvm等） | `decided` | **mise** | [ADR-004](./adr-004-version-manager.md) |
| 005 | プロンプト（Starship / Powerlevel10k等） | `decided` | **Starship**（ADR-003で決定） | [ADR-005](./adr-005-prompt.md) |
| 006 | エディタ / IDE（Neovim / VS Code / Cursor） | `decided` | **Cursor継続 + Claude Code CLI併用** | [ADR-006](./adr-006-editor.md) |

### Layer 3: AI関連

| # | 決定事項 | ステータス | 結論 | 詳細 |
|---|---------|-----------|------|------|
| 007 | Claude Code設定の管理方針 | `decided` | **~/.claude/ をchezmoiで管理** | [ADR-007](./adr-007-claude-code-config.md) |
| 008 | AI skills / hooks / commandsの構成 | `decided` | **AGENTS.md を単一ソース** | [ADR-008](./adr-008-ai-skills-structure.md) |
| 009 | その他AIツール（Cursor等）の設定管理 | `decided` | **Cursor設定をchezmoi symlink管理** | [ADR-009](./adr-009-ai-tools-config.md) |

### Layer 4: 補助ツール・設定

| # | 決定事項 | ステータス | 結論 | 詳細 |
|---|---------|-----------|------|------|
| 010 | Git設定（.gitconfig, hooks, aliases） | `decided` | **既存.gitconfigをそのまま管理** | [ADR-010](./adr-010-git-config.md) |
| 011 | macOS設定の自動化（defaults write等） | `decided` | **スコープ外（今回は行わない）** | [ADR-011](./adr-011-macos-defaults.md) |
| 012 | Homebrew Bundleの構成 | `decided` | **プレーンBrewfile（条件分岐なし）** | [ADR-012](./adr-012-homebrew-bundle.md) |
| 013 | セットアップスクリプト / ブートストラップ | `decided` | **chezmoi init --apply 1コマンド** | [ADR-013](./adr-013-bootstrap.md) |

### Layer 5: 運用

| # | 決定事項 | ステータス | 結論 | 詳細 |
|---|---------|-----------|------|------|
| 014 | Secrets / 認証情報の管理方法 | `decided` | **1Password onepasswordRead** | [ADR-014](./adr-014-credential-management.md) |
| 015 | 複数マシン間の差分管理方針 | `decided` | **差分なし（全マシン同一設定）** | [ADR-015](./adr-015-multi-machine.md) |

---

## 進め方

1. **Layer 1（基盤）から順に決めていく** - 後続の決定に影響するため
2. **各ADRで選択肢を比較し、議論の上で決定する**
3. **決定後もステータスを `revisit` に戻して再検討可能**
4. **依存関係に注意** - 例: dotfiles管理ツール(001)の決定がSecrets管理(014)の選択肢に影響する

## 依存関係

```
001 (dotfiles管理ツール)
 ├── 014 (Secrets管理) ... chezmoiならテンプレート+age暗号化が使える
 ├── 015 (複数マシン差分) ... chezmoiならテンプレートで吸収
 └── 013 (ブートストラップ) ... ツールごとにbootstrap方法が異なる

003 (シェル)
 ├── 005 (プロンプト) ... Fish選択時はStarshipが特に有力
 └── 007 (Claude Code設定) ... シェル依存の設定がある

006 (エディタ)
 └── 008 (AI skills構成) ... エディタ統合に影響
```
