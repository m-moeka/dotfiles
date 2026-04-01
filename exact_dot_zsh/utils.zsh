fzf-select-history() {
  BUFFER=$(history -n 1 | tail -r | fzf --query "$LBUFFER")
  CURSOR=$#BUFFER
  zle clear-screen
}
zle -N fzf-select-history

fzf-git-checkout() {
  local res=$(git branch -a | sed 's/^\*/ /' | awk '{ print $1 }' | fzf)
  if [ -n "$res" ]; then
    BUFFER+="git checkout $res"
    CURSOR=$#BUFFER
  fi
  zle clear-screen
}
zle -N fzf-git-checkout
