function fzf-file() {
  WORD="${LBUFFER##* }"

  items=$( (
    find -L . -mindepth 1 -maxdepth 3 -type d -not -path '*/.git/*' 2>/dev/null | sed -e 's|$|/|' | sort
    find -L . -mindepth 1 -maxdepth 3 -type f 2>/dev/null | sort
  ) | cut -c 3- | fzf --multi --query "${WORD}" --preview-window down,33% --preview "ls -lAh --color {}")

  if [ -z "${items}" ]; then
    return 0
  fi

  if [ ${#WORD} -gt 0 ]; then
    LBUFFER="${LBUFFER:0:-${#WORD}}"
  fi

  num_items=$(echo "${items}" | grep -c '')

  while IFS= read item; do
    file=$(printf %q "${item%/}")
    is_dir=$(test "${item: -1}" = "/"; echo $?)

    if [ "${BUFFER}x" = "x" ]; then
      if [ ${num_items} -eq 1 -a ${is_dir} -eq 0 ]; then
        cd ${file}
        zle accept-line
        return 0
      fi

      case ${OSTYPE} in
        darwin*)
          LBUFFER+="open"
          ;;
        *)
          LBUFFER+="less -S"
      esac
    fi

    if [ "${LBUFFER: -1}" != " " ]; then
      LBUFFER+=" "
    fi
    LBUFFER+="${file}"
  done < <(echo "${items}")
}

zle -N fzf-file
bindkey "^[f" fzf-file
