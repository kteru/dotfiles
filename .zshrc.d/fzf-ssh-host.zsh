function fzf-ssh-host() {
  WORD="${LBUFFER##* }"

  item=$( (
    cat ~/.ssh/config | sed -ne 's/^Host  *//p' | sed -e 's/  */\n/g' | grep -v '*' | sort
  ) | fzf --reverse --query "${WORD}" --preview "cat ~/.ssh/config | grep -v -E '^(\s*|#.*)$' | sed -E -ne '/^Host( *| .*) {}( *| .*)$/,/^[^ ]/p' | sed -e '\$d'")

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

zle -N fzf-ssh-host
bindkey "^[h" fzf-ssh-host
