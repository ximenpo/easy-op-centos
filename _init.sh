#!/usr/bin/env bash

#
#   Usage:  source _init.sh [default_host] [default_group]
#

# install rsync
command -v rsync > /dev/null 2>&1  ||  {
    command -v yum > /dev/null 2>&1  &&  {
        echo    'install rsync now ...'
        yum     install -y  rsync
        command -v   rsync > /dev/null 2>&1    ||  echo    '!!! rsync not found'
    }
}

# init conf
EASYOP_HOST="${1}"
EASYOP_GROUP="${2}"

if [ -z "${EASYOP_GROUP}" ]; then
    EASYOP_GROUP=servers
fi

export  EASYOP_GROUP
export  EASYOP_HOST

if [ ! -e "${EASYOP_GROUP}" ]; then
    echo    "WARN: directory for group [${EASYOP_GROUP}] not found"
fi

if [ ! -e "${EASYOP_GROUP}/${EASYOP_HOST}" ]; then
    echo    "WARN: directory for server [${EASYOP_GROUP}/${EASYOP_HOST}] not found"
fi
