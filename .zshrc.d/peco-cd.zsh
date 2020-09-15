function peco-cd() {
  WORD="${LBUFFER##* }"

  item=$( (
    if [ -x ~/.zshrc.d/peco-cd-list ]; then
      ~/.zshrc.d/peco-cd-list
    else
      ghq list --full-path
    fi
  ) | peco --query "${WORD}" | head -n 1)

  if [ -z "${item}" ]; then
    return 0
  fi

  if [ ${#WORD} -gt 0 ]; then
    LBUFFER="${LBUFFER:0:-${#WORD}}"
  fi

  cd "${item}"
  BUFFER=""
  zle accept-line
}

zle -N peco-cd
bindkey "^[s" peco-cd
