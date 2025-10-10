if command -v keychain >/dev/null 2>&1; then
eval $(keychain --eval --quiet --host keychain)
alias keychain='keychain --host keychain'
fi
