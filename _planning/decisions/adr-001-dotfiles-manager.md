# ADR-001: dotfiles管理ツール

## ステータス: `decided`

## 背景

dotfilesをGitで管理し、複数マシン間で同期するためのツールを選定する。
AIエージェント設定（Claude Code等）も管理対象に含まれるため、テンプレート機能やSecrets管理の柔軟性が重要。

### 現状（刷新前）
- `~/.dotfiles/deploy.sh` で `ln -sfnv` による自前シンボリックリンク方式
- zsh + antigen + Powerlevel10k / anyenv / iTerm2 / ghq + fzy
- Brewfile あり
- マシン差分管理なし（.gitconfigは会社メールのみ）
- Secrets管理は1Passwordだがdotfilesとの連携はなし

### 要件
- 2台のMac（個人 + 会社）で同期
- 1Password CLIとの連携（Secrets管理）
- Claude Code設定（~/.claude/）の管理
- AIファーストなスタックへの大幅刷新を予定

## 選択肢

### A. chezmoi

- **概要**: Go製。テンプレート、暗号化、パスワードマネージャ連携を内蔵
- **メリット**:
  - マシン差分をテンプレートで吸収（ブランチ不要）
  - age/GPGによるSecrets暗号化が標準搭載
  - `chezmoi diff` で適用前にプレビュー可能
  - 最も活発なコミュニティ（GitHub Stars: 13k+）
- **デメリット**:
  - 独自の概念（source state / target state）の学習コスト
  - テンプレートが増えると管理が複雑化
- **向いているケース**: 複数マシン、Secrets管理が必要な場合

### B. GNU Stow

- **概要**: シンボリックリンクファームマネージャ。1つのことだけをシンプルにやる
- **メリット**:
  - 極めてシンプル（`stow パッケージ名` だけ）
  - dotfilesの実体がそのまま見える（テンプレート変換なし）
  - 学習コストがほぼゼロ
- **デメリット**:
  - テンプレート機能なし（マシン差分は自分で管理）
  - Secrets管理は別途必要
  - macOSではbrew installが必要
- **向いているケース**: 単一マシン、シンプルさ重視

### C. Git bare repository

- **概要**: 追加ツール不要。gitのbare repoを$HOMEに対して使う
- **メリット**:
  - 依存ツールなし（gitだけ）
  - gitの知識がそのまま使える
- **デメリット**:
  - .gitignoreの管理が煩雑
  - テンプレート/暗号化は全て自前
  - aliasのセットアップが必要
- **向いているケース**: ミニマリスト、ツール依存を避けたい場合

### D. Nix + home-manager

- **概要**: 完全に宣言的な環境管理。パッケージもdotfilesもNixで統一
- **メリット**:
  - 完全な再現性（declarative & reproducible）
  - パッケージ管理とdotfilesが統合
  - ロールバックが容易
- **デメリット**:
  - 学習コストが非常に高い
  - Nix言語の習得が必要
  - macOSでのエッジケースが多い
  - NixからHomebrew+chezmoiに戻す事例もある
- **向いているケース**: 完全な再現性を最優先する場合

## 評価軸

| 評価軸 | 重み | chezmoi | Stow | bare git | Nix |
|--------|------|---------|------|----------|-----|
| セットアップの容易さ | ★★★ | ○ | ◎ | ○ | △ |
| マシン差分の管理 | ★★★ | ◎ | △ | △ | ◎ |
| Secrets管理 | ★★☆ | ◎ | × | × | ○ |
| 学習コスト | ★★☆ | ○ | ◎ | ◎ | × |
| コミュニティ/エコシステム | ★★☆ | ◎ | ○ | ○ | ○ |
| AI設定との親和性 | ★★★ | ◎ | ○ | ○ | ○ |

## 決定

**A. chezmoi を採用する**

## 決定理由

1. **どうせ大きく変える** — antigen→最新構成、anyenv→mise、iTerm2→Ghostty等、スタック全体を刷新するため、管理ツールも最適なものに乗り換えるコストは相対的に小さい。現在の `deploy.sh`（自前symlink）からの移行は、Stowでもchezmoiでも構成変更が必要。

2. **2台のMac差分管理** — `.gitconfig` のメール（個人 vs 会社）、SSH設定、npm registry token等、マシン固有の設定がテンプレート1つで解決できる。Stowでは `.local` ファイル + gitignore + 手動セットアップが必要。

3. **1Password連携が標準搭載** — `onepasswordRead` テンプレート関数で、Secretsを1Passwordから直接参照可能。gitに秘密情報が入るリスクをゼロにできる。

4. **AIファーストとの相性** — Claude Code設定を含むdotfilesの管理事例がchezmoiコミュニティに多く、参考になるリソースが豊富。

5. **コミュニティの勢い** — GitHub Stars 13k+、2025-2026年のdotfiles記事でも最も言及される管理ツール。

## 日付

2026-03-29
