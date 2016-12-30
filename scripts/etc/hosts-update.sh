#!/usr/bin/env bash

if [ "${1}" = "" ] ;then
    host=${SIMPLE_OP_SSH_HOST}
else
    host=${1}
fi

scp -rp secret/${host}/etc/hosts    ${host}:/etc/
