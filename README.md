# dotfiles

chezmoi で管理する dotfiles。

## セットアップ

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply m-moeka
```

## 構造

```
.
├── dot_zshrc                    # Zinit + Starship + カスタム設定読み込み
├── exact_dot_zsh/               # シェルのカスタム設定（exact: 管理外ファイルを自動削除）
│   ├── alias.zsh                #   エイリアス（workspace移動、git rebase等）
│   ├── path.zsh                 #   mise activate
│   ├── utils.zsh                #   fzf によるhistory/branch検索
│   └── bindkey.zsh              #   キーバインド（^r: history、^o: branch）
├── dot_gitconfig                # Git設定
├── dot_Brewfile                 # Homebrew パッケージ一覧（~/.Brewfile に配置）
├── dot_config/
│   ├── starship.toml            # Starship プロンプト設定
│   ├── ghostty/config           # Ghostty / cmux ターミナル設定
│   └── mise/config.toml         # mise グローバル設定
├── private_dot_claude/          # Claude Code 設定（CLAUDE.md, skills, commands）
├── private_dot_cursor/          # Cursor 設定（mcp.json）
├── private_Library/...          # Cursor エディタ設定（settings.json, keybindings.json）
├── run_onchange_after_install-packages.sh.tmpl  # Brewfile 変更時に brew bundle 実行
└── _planning/                   # 移行計画・ADR（デプロイ対象外）
    ├── migration-review.md      #   旧dotfilesからの移行判定一覧
    ├── chezmoi-source-layout.md #   ソースディレクトリ設計
    └── decisions/               #   Architecture Decision Records
```

## リポジトリ管理の方針

ghq と workspace を併用する。

| 用途 | 場所 | 説明 |
|------|------|------|
| **ghq** | `~/ghq/src/github.com/{owner}/{repo}/` | clone してきただけのリポジトリ。閲覧・参照用 |
| **workspace** | `~/workspaces/{owner}/{repo}/` | Claude ベースでガツガツ作業するリポジトリ |
| **workspace（複数リポ）** | `~/workspaces/{owner}/{workspace-name}/{repo}/` | 複数リポジトリを跨ぐワークスペース |

workspace は Claude Code をワークスペースディレクトリで起動することで、プロジェクト独自の CLAUDE.md・スキル・docs などを git 管理外で自由に配置できる仕組み。

```
~/workspaces/
├── m-moeka/
│   └── dotfiles/              # 単体リポ = owner/repo
└── ascend-ltd/
    └── logix-app/             # 複数リポワークスペース = owner/workspace-name/repo
        └── ascend-logi/
```

エイリアス：
- `ghl` — ghq リポジトリを fzf で選択して移動
- `wsl` — workspace を fzf で選択して移動

## 日常の操作

### 設定を変更する

ソースファイルを編集して適用する：

```bash
# 1. ソースを直接編集（このリポジトリのファイル）
vim dot_zshrc

# 2. 適用前に差分を確認
chezmoi diff

# 3. 適用
chezmoi apply
```

### 新しいファイルを管理に追加する

既に $HOME にあるファイルを chezmoi 管理下に置く：

```bash
chezmoi add ~/.config/foo/config
```

### Homebrew パッケージを追加・削除する

`dot_Brewfile` を編集して適用すると `brew bundle` が自動実行される：

```bash
vim dot_Brewfile
chezmoi apply
```

### 別のマシンで同期する

```bash
chezmoi init --apply m-moeka
```

既にセットアップ済みのマシンで最新を反映：

```bash
git pull
chezmoi apply
```
