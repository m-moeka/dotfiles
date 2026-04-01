---
description: GitHub操作のghコマンドリファレンス。PR作成・確認・マージ、CI/Actions確認に使う。
allowed-tools: Bash
---

# GitHub CLI (gh) リファレンス

## 基本ルール
- `--repo <owner>/<repo>` は必ず明示する（個人・Org混在のため省略禁止）
- PR mergeは必ず `--squash --delete-branch` をつける
- 出力は `--json` + 必要フィールドのみ指定（トークン節約）

## PR

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
# draftの場合は --draft を追加
```

### マージ
```bash
# squash merge統一・ブランチ削除セット
gh pr merge <number> --repo <owner>/<repo> --squash --delete-branch
```

### レビュー
```bash
gh pr review <number> --repo <owner>/<repo> --approve
gh pr review <number> --repo <owner>/<repo> --request-changes --body "..."
```

## CI / Actions

### 確認
```bash
# 直近の実行一覧
gh run list --repo <owner>/<repo> --limit 10 --json databaseId,name,status,conclusion,headBranch

# 特定PRのCI確認
gh pr view <number> --repo <owner>/<repo> --json statusCheckRollup

# 失敗ログのみ表示（原因特定用）
gh run view <run-id> --repo <owner>/<repo> --log-failed
```

### 再実行
```bash
gh run rerun <run-id> --repo <owner>/<repo> --failed-only
```

## よく使う --json フィールド一覧
| 対象 | 推奨フィールド |
|---|---|
| PR一覧 | `number,title,headRefName,isDraft,reviewDecision` |
| PR詳細 | `number,title,body,state,reviews,statusCheckRollup` |
| Run一覧 | `databaseId,name,status,conclusion,headBranch` |