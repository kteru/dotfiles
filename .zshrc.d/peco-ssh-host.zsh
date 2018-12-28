function peco-ssh-host() {
  item=$( (
    cat ~/.ssh/config | sed -ne 's/^Host\s\s*//p' | sed -e 's/\s\s*/\n/g' | grep -v '*' | sort
  ) | peco | head -n 1)

  if [ ! "${item}x" = "x" ]; then
    if [ "${BUFFER}x" = "x" ]; then
      LBUFFER+="ssh "
    fi
    LBUFFER+="${item}"
  fi
}

zle -N peco-ssh-host
bindkey "^[h" peco-ssh-host
