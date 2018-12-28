function peco-ssh-add() {
  items=$( (
    grep -IRl "BEGIN RSA PRIVATE KEY" ~/.ssh
    ssh-add -l | grep -v "The agent has no identities." | awk '{print $3}'
  ) | sort | uniq -c | sed -e 's/^\s*1\s*/  /' -e 's/^\s*2\s*/* /' | peco)

  if [ ! "${items}x" = "x" ]; then
    echo
    echo "${items}" | while IFS= read item; do
      loaded="${item:0:1}"
      keypath="${item:2}"

      if [ "${loaded}" != "*" ]; then
        ssh-add ${keypath}
      else
        ssh-add -d ${keypath}
      fi
    done

    BUFFER=""
    zle accept-line
  fi
}

zle -N peco-ssh-add
bindkey "^[k" peco-ssh-add

function peco-ssh-add-l() {
  echo
  echo -n "$(ssh-add -l)"

  BUFFER=""
  zle accept-line
}

zle -N peco-ssh-add-l
bindkey "^[K" peco-ssh-add-l
