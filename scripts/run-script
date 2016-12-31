#!/usr/bin/env bash

if [ "${2}" = "" ] ;then
    host=${EASY_OP_SSH_HOST}
    script=${1}
else
    host=${1}
    script=${2}
fi

ssh ${host} < ${script}
