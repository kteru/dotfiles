function peco-ssh-add() {
  declare -A added_fingerprints=()
  while IFS= read -r fingerprint; do
    added_fingerprints["${fingerprint}"]=1
  done < <(ssh-add -l | grep -v "The agent has no identities." | awk '{print $2}')

  items=$(
    (
      while IFS= read -r keyfile; do
        fingerprint=$(ssh-keygen -l -f "${keyfile}" 2>/dev/null | awk '{print $2}')

        if [ -n "${added_fingerprints["${fingerprint}"]}" ]; then
          echo "* ${keyfile}"
        else
          echo "  ${keyfile}"
        fi
      done < <(grep -D skip -IRlE "BEGIN .* PRIVATE KEY" ~/.ssh | sort)
    ) | \
    peco
  )

  if [ -z "${items}" ]; then
    return 0
  fi

  echo
  while IFS= read -r item; do
    keyfile="${item:2}"
    added="${item:0:1}"

    if [ "${added}" = " " ]; then
      ssh-add "${keyfile}"
    else
      ssh-add -d "${keyfile}"
    fi
  done < <(echo "${items}")

  BUFFER=""
  zle accept-line
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
