function fzf-ssh-host() {
  WORD="${LBUFFER##* }"

  item=$(
    (
      awk '/^Host / && !/\*/ { for (i=2; i<=NF; i++) print NR, $i }' ~/.ssh/config | \
      sort -k 2
    ) | \
    fzf --query "${WORD}" --with-nth 2.. --preview-window +{1}/4 --preview "grep --color=always -E '^Host(\s*|\s.*)\s{2}(\s*|\s.*)$|^' ~/.ssh/config" | \
    cut -d ' ' -f 2-
  )

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
