function peco-file() {
  item=$( (
    find -L . -mindepth 1 -maxdepth 1 -type d | sed -e 's|^..|/|' | sort
    find -L . -mindepth 1 -maxdepth 1 -type f | sed -e 's|^..| |' | sort
  ) | peco | head -n 1)

  if [ ! "${item}x" = "x" ]; then
    echo "${item}" | grep -q -E '^/'
    is_dir=$?

    item="${item:1}"

    if [ ${is_dir} -eq 0 ]; then
      if [ "${BUFFER}x" = "x" ]; then
        cd "${item}"
        zle accept-line
        return
      fi
    fi

    item=$(printf %q "${item}")
    #ext=${item##*.}

    if [ "${BUFFER}x" = "x" ]; then
      case ${OSTYPE} in
        darwin*)
          LBUFFER+="open "
          ;;
        *)
          LBUFFER+="less -S "
      esac
    fi
    LBUFFER+="${item}"
  fi
}

zle -N peco-file
bindkey "^[f" peco-file
