# ADR-009: その他AIツールの設定管理

## ステータス: `decided`

## 背景

Cursor（メインエディタ）とClaude Code CLI を併用する方針（ADR-006）。両ツールの設定をchezmoiで管理し、マシン間で同期する。

## 決定

**Cursorの設定をchezmoiでsymlink管理する**

### 管理対象
- `~/Library/Application Support/Cursor/User/settings.json` — エディタ設定
- `~/Library/Application Support/Cursor/User/keybindings.json` — キーバインド
- `~/.cursor/mcp.json` — MCP設定（シークレットは1Password経由: ADR-014）

### 管理対象外
- `~/.cursor/extensions/` — 拡張機能本体（各マシンで個別インストール）
- 拡張機能のリストはBrewfile等で管理するか、必要時にスクリプトで復元

### MCP設定のシークレット管理
- `mcp.json` 内のAPIキーはchezmoiテンプレートで1Passwordから取得
- 例: `{{ onepasswordRead "op://Personal/github-pat/token" }}`

## 決定理由

Cursor設定はテキストファイル（JSON）なのでchezmoiで管理しやすい。拡張機能はバイナリで管理が困難なため、設定ファイルのみに絞る。

## 日付

2026-03-31
