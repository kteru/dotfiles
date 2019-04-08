function vscode-here() {
  gittop="$(git rev-parse --show-toplevel 2>/dev/null)"
  if [ "${gittop}x" != "x" ]; then
    (cd "${gittop}"; code .)
  else
    code .
  fi
}

zle -N vscode-here
bindkey "^[v" vscode-here
