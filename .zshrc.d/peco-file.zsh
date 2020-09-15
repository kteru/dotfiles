function peco-file() {
  WORD="${LBUFFER##* }"

  items=$( (
    find -L . -mindepth 1 -maxdepth 1 -type d | sed -e 's|^..|/|' | sort
    find -L . -mindepth 1 -maxdepth 1 -type f | sed -e 's|^..| |' | sort
  ) | peco --query "${WORD}")

  if [ ! "${items}x" = "x" ]; then
    if [ ${#WORD} -gt 0 ]; then
      LBUFFER="${LBUFFER:0:-${#WORD}}"
    fi

    sel_cnt=$(echo "${items}" | wc -l | tr -d ' ')

    echo "${items}" | while IFS= read item; do
      file=$(printf %q "${item:1}")
      is_dir=$(test "${item:0:1}" = "/"; echo $?)

      if [ "${BUFFER}x" = "x" ]; then
        if [ ${sel_cnt} -eq 1 -a ${is_dir} -eq 0 ]; then
          cd ${file}
          zle accept-line
          return
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
    done
  fi
}

zle -N peco-file
bindkey "^[f" peco-file
