function fzf-history() {
  item=$( (
    history -n 1 | tail -r
  ) | fzf --layout default --no-sort --query "${BUFFER}" --preview-window up,33% --preview 'echo {}')

  if [ -z "${item}" ]; then
    return 0
  fi

  BUFFER="${item}"
  CURSOR=${#BUFFER}
}

zle -N fzf-history
bindkey "^[R" fzf-history
