# ADR-010: Git設定

## ステータス: `decided`

## 背景

現在の `.gitconfig` は会社メール（moeka.matsumoto@ascendlogi.co.jp）で設定済み。ghq、tig、git-lfs等も使用中。個人/会社でマシン設定を分ける必要はない。

## 決定

**既存の `.gitconfig` をそのままchezmoiで管理する（テンプレート化不要）**

### 管理対象
- `.gitconfig` — ユーザー設定、ghq、pull戦略、LFS、credential helper等
- `.gitignore_global` — グローバルgitignore（必要に応じて追加）

### 既存設定からの変更点
- credential helperは現行のGit Credential Manager（GCM）を続投（変更なし）
- 必要に応じてエイリアス追加（既存のalias.zshと重複しない範囲で）

## 決定理由

個人/会社でマシン設定を分ける必要がないため、テンプレート化は不要。シンプルにファイルをchezmoiで管理するだけで十分。

## 日付

2026-03-31
