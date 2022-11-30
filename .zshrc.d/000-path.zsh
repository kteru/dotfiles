export PATH="/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:$HOME/bin"

current_arch=$(uname -m)
if [[ ${OSTYPE} =~ ^darwin && ${current_arch} = arm64 ]]; then
  export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/opt/homebrew/sbin:/usr/local/sbin:/usr/sbin:/sbin:$HOME/bin"
fi
