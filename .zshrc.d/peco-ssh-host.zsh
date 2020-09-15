function peco-ssh-host() {
  WORD="${LBUFFER##* }"

  item=$( (
    cat ~/.ssh/config | sed -ne 's/^Host\s\s*//p' | sed -e 's/\s\s*/\n/g' | grep -v '*' | sort
  ) | peco --query "${WORD}" | head -n 1)

  if [ ! "${item}x" = "x" ]; then
    if [ ${#WORD} -gt 0 ]; then
      LBUFFER="${LBUFFER:0:-${#WORD}}"
    fi

    if [ "${BUFFER}x" = "x" ]; then
      LBUFFER+="ssh "
    fi
    LBUFFER+="${item}"
  fi
}

zle -N peco-ssh-host
bindkey "^[h" peco-ssh-host
