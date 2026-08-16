# ADR-016: CodexでのSuperpowers管理

## ステータス: `decided`

## 背景

Codex公式マーケットプレイスのSuperpowersはupstreamより古く、現行CodexのマルチエージェントAPIに追従していない箇所がある。
一方、upstreamを無条件で追従すると、挙動変更やスクリプト更新を確認せず取り込むことになる。

## 決定

- `obra/superpowers`をCodexのGit marketplaceとして登録する
- stable release tagを`~/.codex-pluginfile`で固定する
- 公式マーケットプレイス版と同時にインストールしない
- バージョン変更時はchezmoiの`run_onchange`スクリプトで固定スナップショットを再インストールする
- Codexが`config.toml`へ追記するhook信頼状態とmarketplace状態は、chezmoiテンプレートで保持する
- GitHub Actionsで週次に最新stable tagを確認し、新版があればIssueを作成する
- 更新はIssueで差分を確認し、手動判断する。自動更新しない

## 決定理由

upstreamの現行Codex対応を利用しつつ、再現性と更新時のレビュー機会を確保するため。
GitHub Issueを通知単位にすることで、更新を見落とさず、互換性確認前の自動反映も防げる。

## 日付

2026-08-15
