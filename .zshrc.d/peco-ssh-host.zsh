function peco-ssh-host() {
  WORD="${LBUFFER##* }"

  item=$( (
    cat ~/.ssh/config | sed -ne 's/^Host  *//p' | sed -e 's/  */\n/g' | grep -v '*' | sort
  ) | peco --query "${WORD}" | head -n 1)

  if [ -z "${item}" ]; then
    return 0
  fi

  if [ ${#WORD} -gt 0 ]; then
    LBUFFER="${LBUFFER:0:-${#WORD}}"
  fi

  if [ "${BUFFER}x" = "x" ]; then
    LBUFFER+="ssh "
  fi
  LBUFFER+="${item}"
}

zle -N peco-ssh-host
bindkey "^[h" peco-ssh-host
