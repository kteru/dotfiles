###
### Environment
###

export LANG=ja_JP.UTF-8
export LC_TIME=C
export LC_MESSAGES=C
export PAGER=less
umask 0022


###
### General
###

WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

# No beep
setopt no_beep
setopt nolistbeep

# Changing directories without cd
setopt auto_cd
# Automatically pushd
setopt auto_pushd
# Ignore dups when doing pushd
setopt pushd_ignore_dups

# Spelling correction for commands
setopt correct
# List with less lines
setopt list_packed
# Print eight bit characters
setopt print_eight_bit
# Report background jobs status immediately
setopt notify
# Remove RPROMPT when accepting a command line
setopt transient_rprompt
# Enable substitutions in prompts
setopt prompt_subst


###
### History
###

HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

# Append to the history file rather than replace
setopt append_history
# Append to the history immediately
setopt inc_append_history
# Share history
setopt share_history
# Do not enter into the history when same of the previous command
setopt hist_ignore_dups
# Do not enter into the history when beginning a space
setopt hist_ignore_space
# Remove older same histories
setopt hist_ignore_all_dups
# Do not execute when history expansion
setopt hist_verify


###
### Completion
###

autoload -U compinit && compinit -u

# Smart completion
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' '+m:{A-Z}={a-z}'
# Colorize completion list
zstyle ':completion:*' list-colors ''

# sudo completion
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin
# hosts completion
zstyle -e ':completion:*:hosts' hosts 'reply=(
  ${=${${${${(@M)${(f)"$(cat ~/.ssh/config 2>/dev/null)"}:#Host *}#Host }:#*\**}:#*\?*}}
)'

# Ask only if the top of the listing would scroll off the screen
LISTMAX=0

# Expand for after `=`
setopt magic_equal_subst
# No remove postfix slash
setopt noautoremoveslash


###
### Prompt
###

autoload -U colors && colors

prompt_color=${fg[green]}
if [ ${UID} -eq 0 ]; then
  prompt_color=${fg[yellow]}
fi

PROMPT='%{${prompt_color}%}[%n@%m %1~]%#%{${reset_color}%} '

case ${OSTYPE} in
  darwin*)
    current_arch=$(uname -m)
    RPROMPT='%{${prompt_color}%}(${current_arch})[%40<...<%/]%{${reset_color}%}'
    ;;
  *)
    RPROMPT='%{${prompt_color}%}[%40<...<%/]%{${reset_color}%}'
esac

autoload -U add-zsh-hook

### vcs_info

autoload -U vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats '%c%u%m[%b%i]'
zstyle ':vcs_info:git:*' actionformats '%c%u%m[%b%i|%a]'

autoload -U is-at-least
if is-at-least 4.3.11; then
  zstyle ':vcs_info:git+set-message:*' hooks \
    git-status-count \
    git-stash-count \
    git-nopush-count \
    git-revision

  function +vi-git-status-count() {
    gitstatus=$(git status --porcelain 2>/dev/null)
    staged_cnt=$(echo "${gitstatus}" | grep -c -E '^[^ ?].')
    unstaged_cnt=$(echo "${gitstatus}" | grep -c -E '^.[^ ?]')
    untracked_cnt=$(echo "${gitstatus}" | grep -c -E '^\?\?')

    if [ ${staged_cnt} -gt 0 ]; then
      hook_com[staged]+="+${staged_cnt} "
    fi
    if [ ${unstaged_cnt} -gt 0 ]; then
      hook_com[unstaged]+="*${unstaged_cnt} "
    fi
    if [ ${untracked_cnt} -gt 0 ]; then
      hook_com[misc]+="?${untracked_cnt} "
    fi
  }

  function +vi-git-stash-count() {
    stashed_cnt=$(cat ${hook_com[base]}/.git/logs/refs/stash 2>/dev/null | grep -c '')
    if [ ${stashed_cnt:-0} -gt 0 ]; then
      hook_com[misc]+="s${stashed_cnt} "
    fi
  }

  function +vi-git-nopush-count() {
    nopush_cnt=$(git rev-list remotes/origin/${hook_com[branch]}.. 2>/dev/null | grep -c '')
    if [ ${nopush_cnt:-0} -gt 0 ]; then
      hook_com[misc]+="p${nopush_cnt} "
    fi
  }

  function +vi-git-revision() {
    rev=$(git rev-parse --short HEAD 2>/dev/null)
    if [ -n "${rev}" ]; then
      hook_com[revision]="|${rev}"
    fi
  }
fi

precmd_vcs_info() {
  vcs_info
}

add-zsh-hook precmd precmd_vcs_info

RPROMPT='${vcs_info_msg_0_}'${RPROMPT}

### Execution time

exec_time_msg=""

preexec_exec_time() {
  exec_time_start=$(date '+%s')
}

precmd_exec_time() {
  if [ -n "${exec_time_start}" ]; then
    exec_time_stop=$(date '+%s')
    exec_elapsed=$((exec_time_stop-exec_time_start))
    exec_time_start=""
    exec_time_msg=""
    if [ ${exec_elapsed} -ge 3 ]; then
      exec_time_msg="%{${prompt_color}%}(${exec_elapsed}s)%{${reset_color}%} "
    fi
  fi
}

add-zsh-hook preexec preexec_exec_time
add-zsh-hook precmd precmd_exec_time

RPROMPT='${exec_time_msg}'${RPROMPT}

### Terminal title

precmd_terminal_title() {
  if [[ ${TERM} == [xk]term* || ${TERM} == tmux* || ${TERM} == screen* ]]; then
    # user@host:~/dir
    echo -ne "\033]2;${USER}@${HOST%%.*}:${PWD/~HOME/~}\007"
  fi
}

add-zsh-hook precmd precmd_terminal_title


###
### Keybind
###

bindkey -e

# Delete
bindkey "^[[3~" delete-char
# Home
bindkey "^[[1~" beginning-of-line
# End
bindkey "^[[4~" end-of-line

# Shift-Tab
bindkey "\e[Z" reverse-menu-complete
# Ctrl-p/n
bindkey "^p" history-beginning-search-backward
bindkey "^n" history-beginning-search-forward


###
### Tweaks
###

# Disable bracketed paste mode by default
unset zle_bracketed_paste


###
### Alias
###

setopt complete_aliases

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias tcpdump='tcpdump -nn -s 1600'
alias mysql='mysql --auto-rehash'
alias emacs='emacs -nw'
alias vls='virsh list --all'

case ${OSTYPE} in
  linux*)
    alias ls='ls --color=auto'
    alias systemctl='systemctl --no-pager'
    ;;
  freebsd*)
    alias ls='ls -G'
    command -v gls >/dev/null 2>&1 && alias ls='gls --color=auto --quoting-style=literal'
    ;;
  darwin*)
    alias ls='ls -G'
    command -v gls >/dev/null 2>&1 && alias ls='gls --color=auto --quoting-style=literal'
    command -v ggrep >/dev/null 2>&1 && alias grep='ggrep'
    command -v gsed >/dev/null 2>&1 && alias sed='gsed'
    command -v gawk >/dev/null 2>&1 && alias awk='gawk'
    alias rsync='rsync --iconv=UTF-8-MAC,UTF-8'
    alias ldd='echo Use otool -L'
    alias airport='/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport'
    ;;
esac


###
### Function
###

function encrypt() {
  if [ "${1}x" = "${2}x" ]; then
    echo "error: same file"
    return 1
  fi
  openssl enc -e -aes256 -in ${1} -out ${2}
}

function decrypt() {
  if [ "${1}x" = "${2}x" ]; then
    echo "error: same file"
    return 1
  fi
  openssl enc -d -aes256 -in ${1} -out ${2}
}

function stelnet() {
  openssl s_client -connect ${1}:${2}
}


###
### For tmux
###

# Attach to the existing session or new
function tm() {
  if [ -n "${1}" ]; then
    tmux -2 attach-session -t ${1} || \
      tmux -2 new-session -s ${1}
  else
    tmux -2 attach-session || \
      tmux -2 new-session
  fi
}

alias tmls='tmux list-sessions'


###
### Include
###

# Load from ~/.zshrc.d/*.zsh
for i in ${HOME}/.zshrc.d/*.zsh(N-.); do
  source "${i}"
done
