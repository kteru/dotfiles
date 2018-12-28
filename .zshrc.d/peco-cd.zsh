function peco-cd() {
  item=$( (
    if [ -x ~/.zshrc.d/peco-cd-list ]; then
      ~/.zshrc.d/peco-cd-list
    else
      ghq list --full-path
    fi
  ) | peco | head -n 1)

  if [ ! "${item}x" = "x" ]; then
    cd "${item}"
    BUFFER=""
    zle accept-line
  fi
}

zle -N peco-cd
bindkey "^[s" peco-cd
