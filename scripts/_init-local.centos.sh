#!/usr/bin/env bash

set     -e

cd      $(dirname $0)

# install rsync
command -v rsync > /dev/null 2>&1  ||  {
    echo    'install rsync now ...'
    yum     install -y  rsync
    command -v   rsync > /dev/null 2>&1    ||  echo    '!!! rsync not found'
}
