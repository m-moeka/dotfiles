### lang
# anyenv
eval "$(anyenv init -)"

# go
# export GOENV_DISABLE_GOPATH=1
# export GOPATH="$HOME/ghq"
# export PATH="$PATH:$GOPATH/bin"
# eval "$(goenv init -)"

### brew
export HOMEBREW_BUNDLE_FILE="$HOME/.dotfiles/Brewfile"

### 臨時で使いたいコマンドは ~/bin 配下にシンボリックリンクを作って使う
mkdir -p "$HOME/bin"
export PATH="$HOME/bin:$PATH"
