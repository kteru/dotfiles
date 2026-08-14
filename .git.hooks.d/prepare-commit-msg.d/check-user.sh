#!/usr/bin/env bash

ret=0

if [ "$(git config user.name)" = "" ]; then
  echo "[ERROR] user.name is not set"
  ret=1
fi

if [ "$(git config user.email)" = "" ]; then
  echo "[ERROR] user.email is not set"
  ret=1
fi

exit ${ret}
