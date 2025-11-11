function peco-history() {
  item=$( (
    history -n 1 | tail -r
  ) | peco --layout bottom-up --query "${BUFFER}" | head -n 1)

  if [ -z "${item}" ]; then
    return 0
  fi

  BUFFER="$(echo -ne ${item})"
  CURSOR=${#BUFFER}
}

zle -N peco-history
bindkey "^[R" peco-history
