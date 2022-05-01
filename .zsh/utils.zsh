# fzy
fzy-select-history() {
    local tac
    if which tac > /dev/null; then
        tac="tac"
    else
        tac="tail -r"
    fi
    BUFFER=$(\history -n 1 | \
        eval $tac | \
        fzy --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle clear-screen
}
zle -N fzy-select-history

fzy-git-checkout() {
  local res=$(git branch -a | sed 's/^\*/ /' | awk '{ print $1 }' | fzy)
  if [ -n "$res" ]; then
    BUFFER+="gco $res"
    CURSOR=$#BUFFER
  fi
  zle clear-screen
}
zle -N fzy-git-checkout
