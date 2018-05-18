###
### ENV
###
export LANG=ja_JP.UTF-8
export LC_TIME=C
export LC_MESSAGES=C
export PAGER=less
umask 0022


###
### completion
###
# 補完を有効にする
autoload -U compinit && compinit -u

# 大文字を入力した場合は大文字のみマッチ
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' '+m:{A-Z}={a-z}'
# 補完候補をカラー表示
zstyle ':completion:*' list-colors ''
# sudo でも補完する
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin

# ホスト名の補完候補
zstyle -e ':completion:*:hosts' hosts 'reply=(
  ${=${${${${(@M)${(f)"$(cat ~/.ssh/config 2>/dev/null)"}:#Host *}#Host }:#*\**}:#*\?*}}
)'

# ウィンドウからあふれる時のみ候補表示の確認を行う
LISTMAX=0

# "=" 以降も保管できる
setopt magic_equal_subst
# 末尾のスラッシュを自動削除しない
setopt noautoremoveslash


###
### display
###
# 色
autoload -U colors && colors

# プロンプトにエスケープシーケンスを通す
setopt prompt_subst

# vcs_info を有効にする
autoload -U vcs_info
autoload -U is-at-least
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr ' +'
zstyle ':vcs_info:git:*' unstagedstr ' *'
zstyle ':vcs_info:git:*' formats '%c%u%m [%b]'
zstyle ':vcs_info:git:*' actionformats '%c%u%m [%b|%a]'
if is-at-least 4.3.11; then
  zstyle ':vcs_info:git+set-message:*' hooks git-status-count \
                                             git-stash-count \
                                             git-nopush-count

  function +vi-git-status-count() {
    gitstatus=$(git status --porcelain 2>/dev/null)
    staged_cnt=$(echo "${gitstatus}" | grep -c -E '^[^ ?].')
    unstaged_cnt=$(echo "${gitstatus}" | grep -c -E '^.[^ ?]')
    untracked_cnt=$(echo "${gitstatus}" | grep -c -E '^\?\?')

    if [ ${staged_cnt} -gt 0 ]; then
      hook_com[staged]+="${staged_cnt}"
    fi
    if [ ${unstaged_cnt} -gt 0 ]; then
      hook_com[unstaged]+="${unstaged_cnt}"
    fi
    if [ ${untracked_cnt} -gt 0 ]; then
      hook_com[misc]+=" ?${untracked_cnt}"
    fi
  }

  function +vi-git-stash-count() {
    count=$(git stash list 2>/dev/null | wc -l | tr -d ' ')
    if [ ${count} -gt 0 ]; then
      hook_com[misc]+=" s${count}"
    fi
  }

  function +vi-git-nopush-count() {
    count=$(git rev-list remotes/origin/${hook_com[branch]}.. 2>/dev/null | wc -l | tr -d ' ')
    if [ ${count} -gt 0 ]; then
      hook_com[misc]+=" p${count}"
    fi
  }
fi

# 一般ユーザ
PROMPT='%{${fg[green]}%}[%n@%m %1~]%#%{${reset_color}%} '
RPROMPT='${vcs_info_msg_0_}%{${fg[green]}%}[%50<...<%/]%{${reset_color}%}'

# root
if [ ${UID} = 0 ]; then
  PROMPT='%{${fg[yellow]}%}[%n@%m %1~]%#%{${reset_color}%} '
  RPROMPT='${vcs_info_msg_0_}%{${fg[yellow]}%}[%50<...<%/]%{${reset_color}%}'
fi

# precmd
if [[ ${TERM} == [xk]term* || ${TERM} == screen ]]; then
  precmd() {
    vcs_info
    # ターミナルタイトル表示 user@host:~/dir
    echo -ne "\033]0;${USER}@${HOST%%.*}:${PWD/~HOME/~}\007"
  }
fi


###
### history
###
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000

## root の時にはヒストリ保存しない
#if [ ${UID} = 0 ]; then
#  unset HISTFILE
#  SAVEHIST=0
#fi

# ヒストリファイルに上書きせず追加する
setopt append_history
# 履歴をインクリメンタルに追加
setopt inc_append_history
# 履歴の共有
setopt share_history
# 直前と同じコマンドは追加しない
setopt hist_ignore_dups
# スペースから始まるコマンドは追加しない
setopt hist_ignore_space
# 重複したコマンドは過去の物を削除
setopt hist_ignore_all_dups
# ヒストリ実行前に一旦編集できる状態にする
setopt hist_verify


###
### setting
###
# ビープしない
setopt no_beep
setopt nolistbeep

# cd 無しでも移動
setopt auto_cd
# 自動で pushd する
setopt auto_pushd
# 重複するディレクトリは push しない
setopt pushd_ignore_dups

# コマンド訂正
setopt correct
# リストのコンパクト表示
setopt list_packed
# 8bit 目を通す
setopt print_eight_bit
# ジョブの状態を直ちに知らせる
setopt notify
# コマンド実行後 RPROMPT を消す
setopt transient_rprompt

# 単語区切り文字
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'


###
### bindkey
###
# emacs 風キーバインド
bindkey -e

# Delete
bindkey "^[[3~" delete-char
# Home
bindkey "^[[1~" beginning-of-line
# End
bindkey "^[[4~" end-of-line

# shift-tab - 戻って補完する
bindkey "\e[Z" reverse-menu-complete
# C-p/n - 履歴検索
bindkey "^p" history-beginning-search-backward
bindkey "^n" history-beginning-search-forward


###
### alias
###
# alias でも補完する
setopt complete_aliases

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias tcpdump='tcpdump -nn -s 1600'
alias mysql='mysql --auto-rehash'
alias emacs='emacs -nw'
alias mosh='mosh -a'
alias vls='virsh list --all'

# OS 毎の設定
case ${OSTYPE} in
  linux*)
    alias ls='ls --color=auto'
    alias systemctl='systemctl --no-pager'
    ;;
  freebsd*)
    alias ls='ls -G'
    which gls >/dev/null 2>&1 && alias ls='gls --color=auto --quoting-style=literal'
    ;;
  darwin*)
    alias ls='ls -G'
    which gls >/dev/null 2>&1 && alias ls='gls --color=auto --quoting-style=literal'
    which gsed >/dev/null 2>&1 && alias sed='gsed'
    which gawk >/dev/null 2>&1 && alias awk='gawk'
    alias rsync='rsync --iconv=UTF-8-MAC,UTF-8'
    alias ldd='echo Use otool -L'
    ;;
esac


###
### function
###
# ファイル暗号化
function encrypt() {
  if [ "${1}x" = "${2}x" ]; then
    echo "error: same file"
    return 1
  fi
  openssl enc -e -aes256 -in ${1} -out ${2}
}

# ファイル復号化
function decrypt() {
  if [ "${1}x" = "${2}x" ]; then
    echo "error: same file"
    return 1
  fi
  openssl enc -d -aes256 -in ${1} -out ${2}
}

# s_client
function stelnet() {
  openssl s_client -connect ${1}:${2}
}


###
### for tmux
###
# 既にセッションがある時はアタッチ・無いときは新規作成
function tm() {
  if [ -n "${1}" ]; then
    tmux -2 attach-session -t ${1} || \
      tmux -2 new-session -s ${1}
  else
    tmux -2 attach-session || \
      tmux -2 new-session
  fi
}

# セッションをリストアップ
alias tmls='tmux list-sessions'


###
### load other setting
###
for i in ${HOME}/.zshrc.d/*.zsh(N-.); do
  source "${i}"
done
