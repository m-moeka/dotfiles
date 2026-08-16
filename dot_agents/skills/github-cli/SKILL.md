---
name: github-cli
description: GitHubをgh CLIで操作するための規約とコマンド集。Pull Requestの一覧・確認・作成・マージ・レビュー、GitHub Actionsの状態確認・失敗ログ調査・再実行を依頼されたときに使う。GitHub MCPは使わない。
---

# GitHub CLI

## 基本ルール

- GitHub操作には`gh` CLIを使い、GitHub MCP serverは使わない。
- 対象リポジトリをユーザー指定または現在のGit remoteから特定し、操作コマンドには`--repo <owner>/<repo>`を必ず明示する。
- 読み取り結果は`--json`で必要なフィールドだけを取得する。
- PRをマージするときは`--squash --delete-branch`を必ず指定する。

## Pull Request

### 読み取り

```bash
gh pr list --repo <owner>/<repo> --state open --json number,title,headRefName,isDraft,reviewDecision
gh pr view <number> --repo <owner>/<repo> --json number,title,body,state,reviews,statusCheckRollup
```

### 作成

```bash
gh pr create \
  --repo <owner>/<repo> \
  --base main \
  --head <branch> \
  --title "..." \
  --body "..."
```

Draft PRには`--draft`を追加する。

### マージ

```bash
gh pr merge <number> --repo <owner>/<repo> --squash --delete-branch
```

### レビュー

```bash
gh pr review <number> --repo <owner>/<repo> --approve
gh pr review <number> --repo <owner>/<repo> --request-changes --body "..."
```

## GitHub Actions

### 状態確認と失敗調査

```bash
gh run list --repo <owner>/<repo> --limit 10 --json databaseId,name,status,conclusion,headBranch
gh pr view <number> --repo <owner>/<repo> --json statusCheckRollup
gh run view <run-id> --repo <owner>/<repo> --log-failed
```

### 失敗したjobの再実行

```bash
gh run rerun <run-id> --repo <owner>/<repo> --failed-only
```

## 推奨JSONフィールド

| 対象 | フィールド |
|---|---|
| PR一覧 | `number,title,headRefName,isDraft,reviewDecision` |
| PR詳細 | `number,title,body,state,reviews,statusCheckRollup` |
| Run一覧 | `databaseId,name,status,conclusion,headBranch` |
