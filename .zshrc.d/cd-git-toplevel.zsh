function cd-git-toplevel() {
  gittop="$(git rev-parse --show-toplevel 2>/dev/null)"
  if [ "${gittop}x" != "x" ]; then
    cd "${gittop}"
    BUFFER=""
    zle accept-line
  fi
}

zle -N cd-git-toplevel
bindkey "^[t" cd-git-toplevel
