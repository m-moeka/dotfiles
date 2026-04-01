# ADR-014: Secrets/認証情報の管理

## ステータス: `decided`

## 背景

APIトークン、SSH鍵等のシークレットをdotfilesリポジトリに入れずに管理する方法を決める。既に1Password（またはBitwarden）を使用中。

## 決定

**1Passwordの `onepasswordRead` テンプレート関数でシークレット注入する**

### 管理方法
- chezmoiテンプレート内で `{{ onepasswordRead "op://Vault/Item/field" }}` を使用
- `chezmoi apply` 時に1Password CLIが値を取得→設定ファイルに埋め込み
- Gitには参照先（op://...）のみが残り、実際の値は入らない

### SSH鍵の管理
- 1Password SSH Agentを有効化
- `SSH_AUTH_SOCK` を1Passwordエージェントソケットに設定
- 秘密鍵をディスクに置かない運用

### age暗号化
- 使用しない（1Passwordで十分カバーできるため）

### 適用箇所
- Cursor MCP設定（`~/.cursor/mcp.json`）のAPIキー
- Git署名キー（将来追加する場合）
- その他環境変数でのトークン管理

## 決定理由

既に1Passwordを使用しているため、chezmoiの1Password連携を活用するのが最も自然。age暗号化は鍵管理が追加で必要になるため、1Passwordで統一する方がシンプル。

## 日付

2026-03-31
