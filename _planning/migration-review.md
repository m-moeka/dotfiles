# dotfiles 移行レビュー

現状の `~/.dotfiles` の全設定項目を精査し、新スタックへの移行にあたって「継続」「廃止」「変更」「新規追加」に分類した。
全項目の判断が完了済み。

---

## 1. 廃止するファイル（丸ごと不要になるもの）

| ファイル | 理由 |
|---------|------|
| `.zshrc.antigen` | antigen → Zinit に移行するため不要 |
| `.zsh/antigen/`（ディレクトリごと） | antigen本体。Zinit はbrew or curl でインストールするのでリポジトリに含めない |
| `.p10k.zsh` | Powerlevel10k → Starship に移行するため不要 |
| `deploy.sh` | symlink方式 → chezmoi に移行するため不要 |
| `Brewfile.lock.json` | .gitignore に入っているが、chezmoi移行後も不要 |
| `.zsh/complete.zsh` | AWS CLI補完のみで、MCP経由に移行のため不要。ファイルごと廃止 |

---

## 2. `.zshrc` — 書き換え

現状:
```zsh
# P10k instant prompt（廃止）
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-..." ]]; then
  source "..."
fi

# antigen読み込み（廃止 → Zinit読み込みに変更）
source $HOME/.zshrc.antigen

# カスタム設定読み込み（継続）
for f in $HOME/.zsh/*.zsh; do source "$f"; done

# p10k設定読み込み（廃止）
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# PATH追加（継続）
export PATH="$HOME/.local/bin:$PATH"
```

→ 新しい `.zshrc` では P10k / antigen 関連を全て削除し、Zinit の初期化とプラグイン読み込みに置き換える。`$HOME/.zsh/*.zsh` の読み込みパターンは継続。

---

## 3. `.zsh/alias.zsh` — 項目ごとの判定

| エイリアス | 現在の内容 | 判定 | 理由 |
|-----------|-----------|------|------|
| `ghl` | `ghq list -p \| fzy` でリポジトリ移動 | **変更** | fzy → fzf に書き換え（ghq は継続利用） |
| `wsl` | （新規） | **新規追加** | workspace を fzf で選択して移動 |
| `gbm` | developからpull して現在ブランチにマージ | **変更** | rebase方式に書き換え: `git fetch origin && git rebase origin/develop` |
| `glog` | git log のフォーマット付き表示 | **廃止** | 不要 |
| `relogin` | `exec $SHELL -l` でシェル再起動 | 継続 | 設定変更後に便利。そのまま使える |
| `bu` | `brew update && brew upgrade` | **廃止** | 使っていない |
| `rm_node_modules` | find + rm -rf で node_modules 一括削除 | **廃止** | npx npkill で代替 |
| `rm_tsbuildinfo` | find + rm で tsbuildinfo 一括削除 | **廃止** | 不要 |

---

## 4. `.zsh/path.zsh` — 項目ごとの判定

| 設定 | 現在の内容 | 判定 | 理由 |
|-----|-----------|------|------|
| `eval "$(anyenv init -)"` | anyenv初期化 | **変更** | `eval "$(mise activate zsh)"` に置き換え |
| Go関連（コメントアウト済み） | GOPATH, goenv init | **廃止** | コメントアウトされていて使っていない。削除 |
| `HOMEBREW_BUNDLE_FILE` | Brewfileのパスを指定 | **変更** | パスをchezmoi管理後のパスに変更 |
| `~/bin` の PATH追加 + mkdir | 臨時コマンド用 | **廃止** | 使っていない |

---

## 5. `.zsh/utils.zsh` — 項目ごとの判定

| 関数 | 内容 | 判定 | 理由 |
|-----|------|------|------|
| `fzy-select-history` | fzy でコマンド履歴検索 | **変更** | fzf に書き換え（関数名も変更） |
| `fzy-git-checkout` | fzy でブランチ選択→checkout | **変更** | fzf に書き換え（関数名も変更） |
| `review-start` | git worktree でレビュー用ワークツリー作成 | **廃止** | 使っていない |
| `review-end` | レビュー用ワークツリーを削除 | **廃止** | 使っていない |

---

## 6. `.zsh/bindkey.zsh` — utils.zsh に連動

| キーバインド | 内容 | 判定 |
|------------|------|------|
| `^r` | fzy-select-history → fzf版に連動 | **変更** |
| `^o` | fzy-git-checkout → fzf版に連動 | **変更** |

---

## 7. `.gitconfig` — 項目ごとの判定

| セクション | 内容 | 判定 | 理由 |
|-----------|------|------|------|
| `[user]` name/email | m-moeka / ascendlogi | 継続 | そのまま |
| `[ghq]` root | ~/ghq/src | 継続 | ghq は参照用リポジトリの管理として継続利用 |
| `[pull]` rebase = false | merge方式のpull | 継続 | そのまま |
| `[filter "lfs"]` | git-lfs設定 | 継続 | 必要 |
| `[init]` defaultBranch = develop | デフォルトブランチ名 | 継続 | developのまま |
| `[credential]` GCM | Git Credential Manager | 継続 | ADR-010で決定済み |
| `[credential "https://dev.azure.com"]` | Azure DevOps用 | **廃止** | 使っていない |

---

## 8. `Brewfile` — 最終構成

### 廃止するパッケージ
| パッケージ | 理由 |
|-----------|------|
| `brew 'anyenv'` | mise に移行 |
| `brew 'yarn'` | mise経由で管理（ascend-logiでは `.mise.toml` で yarn 1.22.22 を指定） |
| ~~`brew 'ghq'`~~ | ~~workspaceベースの管理に移行~~ → 継続利用（参照用リポジトリ管理） |
| `brew 'tig'` | 使っていない |
| `brew 'fzy'` | fzf に移行 |
| `cask 'iterm2'` | cmux / Ghostty に移行 |
| `cask 'alfred'`（重複2行あり） | Raycast に移行 |
| `cask 'visual-studio-code'` | Cursor に移行済み |
| `cask 'deepl'` | 不要 |
| `tap 'microsoft/git'` + `cask 'git-credential-manager-core'` | 新しいインストール方法に変更 |
| `mas 'GoodNotes 5'` | 不要 |

### 新規追加するパッケージ
| パッケージ | 理由 |
|-----------|------|
| `brew 'chezmoi'` | dotfiles管理 (ADR-001) |
| `brew 'mise'` | バージョン管理 (ADR-004) |
| `brew 'starship'` | プロンプト (ADR-005) |
| `brew 'fzf'` | fuzzy finder（fzyの後継） |
| `cask 'cmux'` | ターミナル (ADR-002) |
| `cask 'ghostty'` | フォールバックターミナル (ADR-002) |
| `cask 'raycast'` | ランチャー（Alfredの後継） |
| `cask 'git-credential-manager'` | GCM新パッケージ名（tap不要） |
| `brew '1password-cli'` | 1Password CLI (ADR-014) |

### 継続するパッケージ
| パッケージ |
|-----------|
| `brew 'git'` |
| `brew 'gh'` |
| `brew 'jq'` |
| `brew 'mas'` |
| `brew 'openssl'` |
| `brew 'shellcheck'` |
| `brew 'tree'` |
| `brew 'zsh'` |
| `brew 'awscli'` |
| `cask '1password'` |
| `cask 'docker'` |
| `cask 'arc'` |
| `cask 'google-japanese-ime'` |
| `cask 'zoom'` |
| `cask 'cursor'` |
| `cask 'rectangle'` |
| `cask 'slack'` |
| `cask 'todoist'` |
| `mas 'RunCat'` |

---

## 9. 新規作成が必要なファイル

| ファイル | 内容 | ADR |
|---------|------|-----|
| `~/.config/starship.toml` | Starshipプロンプト設定 | ADR-005 |
| `~/.config/ghostty/config` | Ghostty / cmux ターミナル設定 | ADR-002 |
| `~/.config/mise/config.toml` | mise グローバル設定（Node.js等のバージョン指定） | ADR-004 |
| `.chezmoi.toml` | chezmoi設定ファイル | ADR-001 |
| `.chezmoiignore` | chezmoi除外設定 | ADR-001 |
| `run_onchange_before_install-packages.sh` | Homebrew + brew bundle スクリプト | ADR-013 |
| `AGENTS.md`（各プロジェクト） | AI共通指示 | ADR-008 |

---

## 10. 移行手順

### Phase 1: 基盤構築
1. `brew install chezmoi` で chezmoi をインストール
2. `chezmoi init` で新リポジトリを作成（GitHub: m-moeka/dotfiles）
3. `.chezmoi.toml` と `.chezmoiignore` を作成

### Phase 2: シェル環境の移行
4. `.zshrc` を書き換え（P10k/antigen → Zinit/Starship）
5. `.zsh/alias.zsh` を整理（廃止/変更を反映、chezmoi用エイリアス追加）
6. `.zsh/path.zsh` を書き換え（anyenv → mise、~/bin廃止、Go関連削除）
7. `.zsh/utils.zsh` を書き換え（fzy → fzf、review-start/end 削除）
8. `.zsh/bindkey.zsh` を fzf版に更新
9. `.zsh/complete.zsh` を削除
10. `starship.toml` を作成

### Phase 3: ツールチェーンの移行
11. `.gitconfig` を整理（Azure DevOps 削除、ghq は継続）
12. Brewfile を更新（廃止/追加パッケージ反映）
13. `brew bundle` で新パッケージをインストール
14. mise を設定（`~/.config/mise/config.toml`、ascend-logi用 `.mise.toml`）
15. Volta をアンインストール
16. anyenv をアンインストール

### Phase 4: 新規設定
17. cmux / Ghostty の設定ファイルを作成
18. `run_onchange_before_install-packages.sh` を作成
19. 1Password CLI のセットアップ（`op signin`）

### Phase 5: 検証
20. `chezmoi apply` で全体を適用
21. シェルを再起動して動作確認
22. 各ツールの動作確認（fzf、mise、Starship、chezmoi）
23. ascend-logi プロジェクトで `yarn install` / `yarn start` が動くか確認

---

## 11. 追加の考慮事項

- **ghq + workspace 共存**: ghq は clone してきただけの参照用リポジトリ管理として継続。`~/workspaces/{オーナー名}/{リポジトリ名}` または `~/workspaces/{オーナー名}/{ワークスペース名}/{リポジトリ名}` の構造で、Claude ベースで積極的に作業するリポジトリを管理。workspace ディレクトリで Claude Code を起動することで、CLAUDE.md・スキル・docs を git 管理外で自由に配置できる。
- **chezmoiのsourceDir**: `~/workspaces/m-moeka/dotfiles` に設定（`~/.chezmoi.toml` の `sourceDir` で指定）。
- **既存リポジトリ**: `~/ghq/src/` 配下はそのまま維持。workspace が必要なものだけ `~/workspaces/` に `git clone` する。
- **mise + Volta共存**: miseに一本化し、Voltaはアンインストール。ascend-logiの `package.json` にある `volta` フィールドはチームメンバーのために残す。自分用に `.mise.toml` を作成。
- **Voltaメンテナンス終了**: Voltaは公式にメンテナンス終了。チーム全体の mise 移行を将来的に提案する価値あり。
