# ghq
alias ghl='f() { local -r dir="$(ghq list -p | fzf)"; if [[ -n "$dir" ]]; then cd "$dir"; fi; }; f'

# workspace
alias wsl='f() { local -r dir="$(find ~/workspaces -mindepth 2 -maxdepth 2 -type d | fzf)"; if [[ -n "$dir" ]]; then cd "$dir"; fi; }; f'

# git
alias gbm='git fetch origin && git rebase origin/develop'

# shell
alias relogin='exec $SHELL -l'
