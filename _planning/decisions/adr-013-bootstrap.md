# ADR-013: セットアップスクリプト/ブートストラップ

## ステータス: `decided`

## 背景

新しいMacのセットアップを最小の手順で完了させたい。現在は `deploy.sh` でシンボリックリンクを張り、Homebrewとantigenをインストールする手動プロセス。

## 決定

**`chezmoi init --apply` による1コマンドセットアップ**

### セットアップフロー
```bash
# Step 1: chezmoi + brew bundle（1Password CLI含む）
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply m-moeka
# → onepasswordRead テンプレートの解決でエラーになる可能性あり

# Step 2: 1Passwordにサインイン
eval $(op signin)

# Step 3: テンプレートを含むdotfilesを再適用
chezmoi apply
```

### 実行される内容（順序）
1. chezmoiがインストールされる
2. dotfilesリポジトリがクローンされる
3. `run_onchange_before_install-packages.sh` — Homebrew + `brew bundle`（1Password CLI含む）
4. dotfilesが `~` に配置される（.zshrc, .gitconfig, ~/.claude/ 等）
5. ※ `onepasswordRead` を使うテンプレートは、`op signin` 前だと失敗する
6. `op signin` 後に `chezmoi apply` を再実行して完了

### 前提
- マシン差分なし（個人/会社で設定を分けない）
- `.chezmoi.toml.tmpl` による初回質問は不要
- 1Password CLIはBrewfileでインストールされるが、初回の `op signin` は手動で必要
- 完全な1コマンドセットアップにはならず、最低3ステップ必要

## 決定理由

chezmoiの `init --apply` は1コマンドでクローン→適用→スクリプト実行を一気通貫で行える。現在の `deploy.sh` + 手動 Homebrew インストールを完全に置き換えられる。

## 日付

2026-03-31
