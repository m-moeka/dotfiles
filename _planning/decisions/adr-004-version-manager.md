# ADR-004: バージョンマネージャ

## ステータス: `decided`

## 背景

現在 anyenv を使用中（Brewfileに記載）。anyenvはnodenv, pyenv等の `*env` 系を束ねるラッパーだが、各envの初期化で起動時間が増加し、設定も分散する。

### 現状（刷新前）
- anyenv（`.zsh/path.zsh` で `eval "$(anyenv init -)"` を実行）
- 主にNode.js（nodenv経由）を管理
- 起動時間への悪影響あり

## 選択肢

### A. mise（旧rtx）
- Rust製。anyenvの完全上位互換。1ツールで全ランタイム管理
- タスクランナー・環境変数管理を内蔵
- `mise.toml` で設定（`.tool-versions` asdf互換も可）
- 起動時間ほぼゼロ。asdfより2-7倍高速

### B. fnm（Fast Node Manager）
- Rust製。Node.js専用で最速（`fnm use` 4ms）
- Python等は管理できない。別途pyenv等が必要

### C. asdf（Go書き直し版）
- 2025年にGoでリライト。polyglot対応
- miseより遅い。タスクランナー・環境変数管理なし

### D. nvm / Volta
- nvm: 起動300ms〜3秒の遅延。新規採用理由なし
- Volta: pnpmサポートが実験的。Node.js専用

## 決定

**A. mise を採用する**

## 決定理由

1. **anyenvの完全置き換え** — 複数の `*env` を1ツール・1設定ファイルに統合。anyenvで管理していたNode.js + 他ランタイムをそのまま移行可能
2. **起動速度の劇的改善** — anyenvの `eval "$(anyenv init -)"` による遅延がゼロに。Rust製バイナリで起動への影響がほぼない
3. **追加機能** — タスクランナー（`mise run`）と環境変数管理が内蔵。direnvやMakefile的な用途も1ツールで対応
4. **chezmoi管理が容易** — `~/.config/mise/settings.toml` 1箇所をchezmoiで管理すれば完了
5. **エコシステムの勢い** — 2025-2026年のdotfiles記事で最も推奨されるバージョンマネージャ

## 日付

2026-03-31
