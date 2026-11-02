# ADR-016: CodexでのSuperpowers管理

## ステータス: 廃止（2026-11-02）

## 廃止理由

公式マーケットプレイス版のSuperpowersで普段の利用に困っておらず、固定版は実際には有効化されていなかった。
週次で作成される更新Issue（v6.4.1〜v7.0.1）も処理されておらず、レビューの仕組みが機能していなかった。
他人製のプラグインやスキルは入れ替えが多く、chezmoiで管理する手間に見合わないため、`dot_codex-pluginfile`、インストールスクリプト、週次のGitHub Actionsを削除した。
以下は当時の記録として残す。

## 背景

Codex公式マーケットプレイスのSuperpowersはupstreamより古く、現行CodexのマルチエージェントAPIに追従していない箇所がある。
一方、upstreamを無条件で追従すると、挙動変更やスクリプト更新を確認せず取り込むことになる。

## 決定

- `obra/superpowers`をCodexのGit marketplaceとして登録する
- stable release tagを`~/.codex-pluginfile`で固定する
- 公式マーケットプレイス版と同時にインストールしない
- バージョン変更時はchezmoiの`run_onchange`スクリプトで固定スナップショットを再インストールする
- Codexが`config.toml`へ追記するhook信頼状態とmarketplace状態は、`config.toml`をchezmoiで上書きしないことで保持する（2026-11-02変更: テンプレートで引き継ぐ方式をやめ、`create_`で新規マシンに基準値を一度だけ作る方式にした）
- GitHub Actionsで週次に最新stable tagを確認し、新版があればIssueを作成する
- 更新はIssueで差分を確認し、手動判断する。自動更新しない

## 決定理由

upstreamの現行Codex対応を利用しつつ、再現性と更新時のレビュー機会を確保するため。
GitHub Issueを通知単位にすることで、更新を見落とさず、互換性確認前の自動反映も防げる。

## 日付

2026-08-15
