function peco-ssh-add() {
  items=$( (
    grep -IRl "BEGIN RSA PRIVATE KEY" ~/.ssh
    ssh-add -l | grep -v "The agent has no identities." | awk '{print $3}'
  ) | sort | uniq -c | sed -e 's/^\s*1\s*/  /' -e 's/^\s*2\s*/* /' | peco)

  if [ ! "${items}x" = "x" ]; then
    echo
    echo "${items}" | while IFS= read item; do
      key="${item:2}"
      is_loaded=$(test "${item:0:1}" = "*"; echo $?)

      if [ ${is_loaded} -ne 0 ]; then
        ssh-add ${key}
      else
        ssh-add -d ${key}
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
