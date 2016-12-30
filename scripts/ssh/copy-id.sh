#!/usr/bin/env bash

if [ "${2}" = "" ] ;then
    host=${SIMPLE_OP_SSH_HOST}
    keyfile=${1}
    shift
else
    host=${1}
    shift
    keyfile=${1}
    shift
fi

KEYFILE=$1
shift

which ssh-copy-id > /dev/null || {
    echo    'ERROR: no ssh-copy-id found'
}
which ssh-copy-id > /dev/null && {
    ssh-copy-id -i "${keyfile}" -o PreferredAuthentications=password $@ ${host}
}
