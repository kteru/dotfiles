function peco-file() {
  WORD="${LBUFFER##* }"

  items=$( (
    find -L . -mindepth 1 -maxdepth 1 -type d | sed -e 's|^..|/|' | sort
    find -L . -mindepth 1 -maxdepth 1 -type f | sed -e 's|^..| |' | sort
  ) | peco --query "${WORD}")

  if [ -z "${items}" ]; then
    return 0
  fi

  if [ ${#WORD} -gt 0 ]; then
    LBUFFER="${LBUFFER:0:-${#WORD}}"
  fi

  num_items=$(echo "${items}" | wc -l | tr -d ' ')

  while IFS= read item; do
    file=$(printf %q "${item:1}")
    is_dir=$(test "${item:0:1}" = "/"; echo $?)

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

zle -N peco-file
bindkey "^[f" peco-file
