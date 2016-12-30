#!/usr/bin/env bash

set     -e

cd      $(dirname $0)

# # install ansible
# which ansible > /dev/null 2>&1  ||  {
#     echo    'install ansible now ...'
#     which   yum > /dev/null 2>&1    &&  yum     install -y  ansible
#     which   yum > /dev/null 2>&1    ||  echo    '!!! yum not found'
# }

# install rsync
which rsync > /dev/null 2>&1  ||  {
    echo    'install rsync now ...'
    which   yum > /dev/null 2>&1    &&  yum     install -y  rsync
    which   yum > /dev/null 2>&1    ||  echo    '!!! yum not found'
}
