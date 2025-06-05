function fzf-ssh-add() {
  items=$(
    (
      grep -D skip -IRlE "BEGIN .* PRIVATE KEY" ~/.ssh
      ssh-add -l | grep -v "The agent has no identities." | awk '{print $3}'
    ) | \
    sort | uniq -c | sed -e 's/^ *1 */  /' -e 's/^ *[23] */* /' | \
    fzf --multi
  )

  if [ -z "${items}" ]; then
    return 0
  fi

  echo
  while IFS= read item; do
    key="${item:2}"
    is_loaded=$(test "${item:0:1}" = "*"; echo $?)

    if [ ${is_loaded} -ne 0 ]; then
      ssh-add "${key}"
    else
      ssh-add -d "${key}"
    fi
  done < <(echo "${items}")

  BUFFER=""
  zle accept-line
}

zle -N fzf-ssh-add
bindkey "^[k" fzf-ssh-add

function fzf-ssh-add-l() {
  echo
  echo -n "$(ssh-add -l)"

  BUFFER=""
  zle accept-line
}

zle -N fzf-ssh-add-l
bindkey "^[K" fzf-ssh-add-l
