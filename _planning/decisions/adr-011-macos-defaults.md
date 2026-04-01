# ADR-011: macOS設定の自動化

## ステータス: `decided`

## 背景

macOS設定（Finder、Dock、トラックパッド等）を `defaults write` コマンドで自動化し、新しいMacでも一発で自分好みにする。

## 決定

**macOS defaults の自動化は行わない（スコープ外）**

macOS設定の `defaults write` 自動化は優先度が低いため、今回のdotfiles刷新には含めない。必要性を感じた時点で改めて検討する。

## 決定理由

dotfiles刷新の主目的はAIファーストな開発環境の構築であり、macOS設定の自動化はそのスコープ外。手動設定で十分対応できる。

## 日付

2026-03-31
