# ADR-003: シェル

## ステータス: `decided`

## 背景

現在 zsh + antigen + Powerlevel10k を使用中。antigenは非推奨化、Powerlevel10kは2025年2月からメンテ停止（ライフサポート状態）。AIファーストなスタック刷新に合わせて、シェル環境を見直す。

### 現状（刷新前）
- zsh + antigen（プラグインマネージャ）+ Powerlevel10k（プロンプト）
- プラグイン: oh-my-zsh(git), zsh-completions, zsh-syntax-highlighting, zsh-autosuggestions
- カスタム関数: fzy-select-history, fzy-git-checkout, review-start/end
- anyenv でNode.js等のバージョン管理

## 選択肢

### A. zsh モダン化
- antigen → **Zinit**（Turboモードで起動50-80%高速化）
- Powerlevel10k → **Starship**（Rust製、クロスシェル対応、活発にメンテ）
- anyenv → **mise**（バージョン管理 + 環境変数 + タスクランナー統合）
- 既存のカスタム関数・aliasはそのまま移行可能
- POSIX完全互換、Claude Code公式対応

### B. fish に乗り換え
- syntax highlight、補完、サジェスト全てビルトイン（ゼロ設定）
- Fish 4.0+（Rust書き直し済み）で起動<100ms
- POSIX非互換（変数設定 `set VAR value`、制御構文 `end` 等）
- Claude Codeとの既知の非互換（GitHub issue #13425）
- 既存の全カスタム関数・aliasを書き直す必要あり

## 評価

| 観点 | zshモダン化 | fish |
|------|-----------|------|
| Claude Code互換 | ◎ 公式対応 | △ ワークアラウンド必要 |
| 既存資産の移行 | ◎ そのまま | × 全書き直し |
| コピペ互換性 | ◎ POSIX互換 | △ 動かないことがある |
| 初期セットアップ | ○ Zinit+数プラグイン | ◎ ほぼゼロ |
| 起動速度 | ○ 100-200ms（Turboモード） | ◎ <100ms |

## 決定

**A. zsh モダン化を採用する**

具体的な刷新内容:
- プラグインマネージャ: antigen → **Zinit**（Turboモード）
- プロンプト: Powerlevel10k → **Starship**
- バージョン管理: anyenv → **mise**（ADR-004で正式決定予定）
- 既存プラグイン（zsh-completions, zsh-syntax-highlighting, zsh-autosuggestions）は継続
- カスタム関数（fzy系、review-start/end）はそのまま移行

## 決定理由

1. **Claude Code公式対応** — AIファーストを掲げるプロジェクトで、Claude Codeとの非互換はリスクが大きすぎる。fishには公式未対応のシェルスナップショット問題（#13425）がある
2. **既存資産の活用** — fzy-select-history、fzy-git-checkout、review-start/endなど実用的なカスタム関数がそのまま使える。書き直しの手間がゼロ
3. **POSIX互換性** — CI/CD、Dockerfile、READMEのコマンド例がそのまま動く。仕事で使うスクリプトとの摩擦なし
4. **モダン化で十分** — fishの魅力（ゼロ設定の補完・ハイライト）は、zshでもZinit + 既存プラグインで実現済み。プロンプトをStarshipに変え、anyenvをmiseに変えるだけで十分モダンな環境になる

## 副次的決定（ADR-005 プロンプトにも影響）

- Starshipの採用はこの決定に含む（Powerlevel10kのメンテ停止が直接の理由）
- Zinitの採用はこの決定に含む（antigenの非推奨化が直接の理由）

## 日付

2026-03-30
