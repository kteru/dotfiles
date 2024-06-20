function fzf-cd() {
  WORD="${LBUFFER##* }"

  item=$( (
    if [ -x ~/.zshrc.d/fzf-cd-list ]; then
      ~/.zshrc.d/fzf-cd-list
    else
      ghq list --full-path
    fi
  ) | fzf --query "${WORD}" --preview-window down,33% --preview "ls -lAh --color {}")

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

zle -N fzf-cd
bindkey "^[s" fzf-cd
