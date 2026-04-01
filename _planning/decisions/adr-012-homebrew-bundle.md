# ADR-012: Homebrew Bundleの構成

## ステータス: `decided`

## 背景

現在Brewfileで開発ツール（ghq, git, gh等）とアプリ（1password, cursor, docker等）を管理中。個人/会社で分ける必要はない。

## 決定

**Brewfileをプレーンファイルとしてchezmoiで管理する**

### 構成
- Brewfileは1つ（条件分岐なし）
- `Brewfile.lock.json` はgitignore
- インストールは `run_onchange_before_` スクリプトで `brew bundle` 実行

### 刷新時のBrewfile更新内容
- 追加: `chezmoi`, `mise`, `starship`, `fzf`, `cmux`, `ghostty`, `raycast`, `git-credential-manager`, `1password-cli`
- 削除: `anyenv`（mise）, `yarn`（mise）, `ghq`（workspaceベース）, `tig`（未使用）, `fzy`（fzf）, `iterm2`（cmux）, `alfred`（Raycast）, `visual-studio-code`（Cursor）, `deepl`（未使用）, `tap 'microsoft/git'` + `git-credential-manager-core`（新パッケージ名に変更）, `mas 'GoodNotes 5'`（未使用）
- 維持: `git`, `gh`, `jq`, `mas`, `openssl`, `shellcheck`, `tree`, `zsh`, `awscli`, `1password`, `docker`, `arc`, `google-japanese-ime`, `zoom`, `cursor`, `rectangle`, `slack`, `todoist`, `mas 'RunCat'`

## 決定理由

個人/会社の差分がないため、テンプレート化は不要。プレーンファイルにすることで中身が見やすく、chezmoiの学習コストも最小化。

## 日付

2026-03-31
