#!/usr/bin/env bash

if [ "$(git config --local user.name)" = "" ]; then
  echo "[ERROR] user.name is not set locally"
  ret=1
fi

if [ "$(git config --local user.email)" = "" ]; then
  echo "[ERROR] user.email is not set locally"
  ret=1
fi

exit ${ret}
