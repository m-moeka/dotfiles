# ghe
alias gh='f() { local -r go_to="$(ghq list -p | fzy)"; if [[ -n "$go_to" ]]; then cd "$go_to"; fi; }; f'
alias gbm='c=$(git rev-parse --abbrev-ref HEAD) && gco develop && gl && gco $c && gl origin develop'
alias glog="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

# shell
alias relogin='exec $SHELL -l'

# brew 
alias bu='brew update && brew upgrade'

# delete node_modules
alias rm_node_modules='find . -name "node_modules" -type d -prune | xargs -p rm -rf'
