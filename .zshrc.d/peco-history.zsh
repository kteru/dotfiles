function peco-history() {
  item=$( (
    history -n 1 | tail -r
  ) | peco --layout bottom-up --query "${BUFFER}" | head -n 1)

  if [ ! "${item}x" = "x" ]; then
    BUFFER="${item}"
    CURSOR=${#BUFFER}
  fi
}

zle -N peco-history
bindkey "^[R" peco-history
