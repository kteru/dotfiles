#
# completion
#
autoload -U compinit
compinit
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' '+m:{A-Z}={a-z}'
zstyle ':completion:*' list-colors ''


#
# display
#
PROMPT=$'%{\e[32m%}[%n@%m %1~]%#%{\e[m%} '
RPROMPT=$'%{\e[32m%}[%/]%{\e[m%}'
if [ $UID = 0 ]; then
  PROMPT=$'%{\e[33m%}[%n@%m %1~]%#%{\e[m%} '
  RPROMPT=$'%{\e[33m%}[%/]%{\e[m%}'
fi

if [[ $TERM == [xk]term || $TERM == screen ]]; then
  precmd() {
    echo -ne "\033]0;${USER}@${HOST%%.*}:${PWD/~HOME/~}\007"
  }
fi


#
# history
#
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
LISTMAX=0
#if [ $UID = 0 ]; then
#  unset HISTFILE
#  SAVEHIST=0
#fi

setopt append_history
setopt inc_append_history
setopt share_history
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_ignore_space


#
# bindkey
#
bindkey -e
bindkey "^[[3~" delete-char
bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line
bindkey "\e[Z" reverse-menu-complete
bindkey "^p" history-beginning-search-backward
bindkey "^n" history-beginning-search-forward


#
# setting
#
setopt no_beep
setopt nolistbeep
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
setopt magic_equal_subst
setopt correct
setopt list_packed
setopt noautoremoveslash
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'


#
# alias, env
#
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias emacs='TERM=xterm-256color emacs -nw'
alias vls='virsh list --all'
export PAGER=less
case ${OSTYPE} in
  linux*)
    alias ls='ls --color=auto'
    ;;
  freebsd*)
    alias ls='ls -G'
    alias vi='vim'
    ;;
esac


#
# function
#
function findgrep() {
  find ${2} -print0 | xargs -0 grep -n "${1}"
}


#
# for tmux
#
alias tm='tmux -2 attach || tmux -2'

if [ "$TMUX" != "" ]; then
  function _tmux_new-window_keep_pwd() {
    PWD=`pwd` tmux new-window
  }
  zle -N _tmux_new-window_keep_pwd

  function _tmux_split-window_keep_pwd() {
    PWD=`pwd` tmux split-window
  }
  zle -N _tmux_split-window_keep_pwd

  bindkey "^[n" _tmux_new-window_keep_pwd
  bindkey "^[m" _tmux_split-window_keep_pwd
fi

