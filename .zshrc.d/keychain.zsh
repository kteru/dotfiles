# keychain
if which keychain > /dev/null 2>&1; then
  keychain --quiet ~/.ssh/id_rsa
  source ~/.keychain/$HOST-sh
fi

