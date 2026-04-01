# ADR-002: ターミナルエミュレータ

## ステータス: `decided`

## 背景

現在iTerm2を使用中。AIファーストなスタックへの刷新に合わせ、ターミナルエミュレータも見直す。
dotfiles管理にchezmoiを採用したため（ADR-001）、テキストベースの設定ファイルで管理できることが重要。

### 現状（刷新前）
- iTerm2（Brewfileに記載、長期使用）
- GUI設定（plist）のため、dotfilesでの管理が困難

## 選択肢

### A. cmux（Ghosttyベース・AIエージェント特化）
- libghosttyを描画エンジンに使用、Swift+AppKit製のネイティブmacOSアプリ
- 垂直タブ（gitブランチ・PR状態・ポート表示）、通知リング、組み込みブラウザ、Socket API
- Ghosttyの設定ファイル (`~/.config/ghostty/config`) をそのまま読む
- 2026年2月リリース、GitHub 11.2k stars、YCスタートアップ（2人チーム）、AGPL

### B. Ghostty
- Mitchell Hashimoto（HashiCorp共同創業者）がZigで開発、Metal GPU加速
- 407FPS、起動50ms以下、メモリ129MB
- `~/.config/ghostty/config`（key=value形式）で設定
- 2024年末公開、GitHub 48.7k stars、Hack Club 501(c)(3)傘下

### C. WezTerm
- Rust製、Lua設定、クロスプラットフォーム
- メモリ320MB、フォントレンダリングの問題あり

### D. Alacritty
- ミニマル、タブ・スプリットなし、tmux前提

### E. iTerm2（現状維持）
- CPU描画、GUI設定（dotfiles管理困難）

## 選考過程

1. **WezTerm除外**: メモリ消費大、フォントレンダリング問題、macOSネイティブ感が薄い
2. **Alacritty除外**: タブ・スプリット非搭載でtmux必須。tmux未使用の現状から追加学習コストが大きい
3. **iTerm2除外**: CPU描画で性能劣位、GUI設定がchezmoi管理と相性悪い
4. **cmux vs Ghostty**: cmuxはGhosttyの描画エンジン上のスーパーセット。設定互換あり

### cmuxのリスク評価（日本語IME）

調査時点で以下のIME関連バグが報告・修正済み:
- CJK入力の完全不具合（PR #125で修正）
- Shift+Space IME切替時の余計なスペース（#641 → PR #670で修正）
- ブラウザアドレスバーでの日本語入力不可（#789 → PR #867で修正）
- 変換確定Enterがコマンド実行になる（#1671 → #2075で修正）

全てマージ済みだが、新機能追加時にIMEが壊れるリスクは残る。
ただしcmuxとGhosttyは設定互換のため、撤退コストはほぼゼロ。

## 決定

**A. cmux をメインターミナルとして採用する。問題が発生した場合はGhosttyにフォールバックする。**

設定ファイルは `~/.config/ghostty/config` をchezmoiで管理し、cmux/Ghostty両方から参照される構成とする。

## 決定理由

1. **AIファーストの方針に最も合致** — Claude Code等を複数並行実行する際の通知リング、Socket API、組み込みブラウザがAIエージェント活用を前提とした設計
2. **Ghosttyとの設定互換** — `~/.config/ghostty/config` を共有するため、chezmoiで1つの設定を管理すれば両方で動く。フォールバック先が常に確保されている
3. **退路のコストがゼロ** — cmuxで問題があればGhosttyをインストールするだけで同じ設定が使える
4. **chezmoi管理との相性** — テキストベースの key=value 設定ファイルなので、テンプレート化も容易

## 日付

2026-03-29
