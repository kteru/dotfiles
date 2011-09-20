#!/bin/sh
#
# 20110902
# create slinks in home directory
#
PATH=/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/sbin:/usr/sbin
export PATH

for i in `cat ${PWD}/slink.files`
do
  ln -fs ${PWD}/${i} ${HOME}/${i}
done

