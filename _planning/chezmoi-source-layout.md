# chezmoi ソースディレクトリ構成

## ディレクトリツリー

```
~/workspaces/m-moeka/dotfiles/          ← sourceDir
│
├── .chezmoiignore                      # 除外設定
│
│  ── Shell ──────────────────────────
├── dot_zshrc                           → ~/.zshrc
├── exact_dot_zsh/                      → ~/.zsh/（exact: antigen/, complete.zsh を自動削除）
│   ├── alias.zsh
│   ├── path.zsh
│   ├── utils.zsh
│   └── bindkey.zsh
│
│  ── Git ────────────────────────────
├── dot_gitconfig                       → ~/.gitconfig
│
│  ── XDG Config ─────────────────────
├── dot_config/
│   ├── starship.toml                   → ~/.config/starship.toml
│   ├── ghostty/
│   │   └── config                      → ~/.config/ghostty/config
│   └── mise/
│       └── config.toml                 → ~/.config/mise/config.toml
│
│  ── Claude Code（ADR-007）────────
├── private_dot_claude/                 → ~/.claude/（private: 0700）
│   ├── CLAUDE.md
│   ├── settings.json
│   ├── commands/
│   │   └── github.md
│   └── skills/
│       ├── find-skills/
│       ├── pr-drawio/
│       └── vercel-react-best-practices/
│
│  ── Cursor（ADR-009）───────────
├── private_dot_cursor/                 → ~/.cursor/（private: 0700）
│   └── mcp.json.tmpl                  → ~/.cursor/mcp.json（1Passwordテンプレート）
├── Library/
│   └── Application Support/
│       └── Cursor/
│           └── User/
│               ├── settings.json       → ~/Library/.../settings.json
│               └── keybindings.json    → ~/Library/.../keybindings.json
│
│  ── Homebrew（ADR-012）──────────
├── dot_Brewfile                        → ~/.Brewfile
│
│  ── Bootstrap（ADR-013）─────────
├── run_onchange_before_install-packages.sh.tmpl
│
│  ── リポジトリ専用（デプロイしない）──
├── _planning/
├── README.md
└── .git/
```

## 設計判断

### exact_dot_zsh/（exact prefix）
- `exact_` により `~/.zsh/` 内の管理外ファイルを自動削除
- 廃止対象の `antigen/` と `complete.zsh` が `chezmoi apply` で自動クリーンアップ
- 今後 `~/.zsh/` は chezmoi が唯一の管理者

### private_dot_claude/（exact なし）
- `~/.claude/` にはchezmoi管理外のシステムディレクトリ（`projects/`, `file-history/`, `backups/` 等）が多数
- `exact_` を付けるとそれらが全削除されるため、付けない

### Brewfile → ~/.Brewfile
- `dot_Brewfile` としてホームに配置し、`brew bundle --global` で参照
- `path.zsh` の `HOMEBREW_BUNDLE_FILE` は不要（`--global` は `~/.Brewfile` をデフォルトで読む）
- `run_onchange_` スクリプトは `{{ include "dot_Brewfile" | sha256sum }}` でBrewfile変更を検知

### .chezmoiignore
```
_planning/
README.md
```

### .chezmoi.toml は不要
- ADR-015: マシン差分なし → テンプレート変数不要
- ADR-013: 対話的質問なし
- sourceDir は `chezmoi init --source` で指定
