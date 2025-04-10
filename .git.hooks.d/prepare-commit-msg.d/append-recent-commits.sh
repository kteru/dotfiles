#!/usr/bin/env bash

if [ "${2}" = "" ]; then
  (
    echo "# Recent commits:"
    git log --oneline --no-merges -n 30 2>/dev/null | sed -e $'s/^/#\t/'
    echo "#"
  ) >> "${1}"
fi
